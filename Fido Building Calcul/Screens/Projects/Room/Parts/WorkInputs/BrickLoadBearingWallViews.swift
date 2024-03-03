//
//  BrickLayingOfLoadBearingWall.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct BrickLoadBearingWallViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @Environment(\.managedObjectContext) var viewContext
    var scrollProxy: ScrollViewProxy
    
    init(room: Room, scrollProxy: ScrollViewProxy) {
        
        self.scrollProxy = scrollProxy
        
        let roomRequest = Room.fetchRequest()
        
        roomRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: true)]
        
        let cUUID = room.cId ?? UUID()
        
        roomRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedRoom = FetchRequest(fetchRequest: roomRequest)
        
    }
    
    var body: some View {
        
        if let room = fetchedRoom.first {
            
            VStack {
                
                HStack {
                        
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(BrickLoadBearingWall.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(BrickLoadBearingWall.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                        Spacer()
                    
                        Button {
                            createBrickLayingOfBreaingWalls(to: room)
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 22))
                                .foregroundColor(.brandBlack)
                                .frame(width: 35, height: 35)
                                .background(Color.brandWhite)
                                .clipShape(Circle())
                            
                        }
                    
                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                .onTapGesture {  createBrickLayingOfBreaingWalls(to: room) }
                    
                    if !room.associatedBrickLoadBearingWalls.isEmpty {
                        
                        ForEach(room.associatedBrickLoadBearingWalls) { loopedObject in
                            
                            let objectCount = room.associatedBrickLoadBearingWalls.count - (room.associatedBrickLoadBearingWalls.firstIndex(of: loopedObject) ?? 0)
                        
                            BrickLoadBearingWallEditor(brickLoadBearingWall: loopedObject, objectCount: objectCount)
                        
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                        
                    }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedBrickLoadBearingWalls.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createBrickLayingOfBreaingWalls(to room: Room) {
        
        withAnimation { scrollProxy.scrollTo(BrickLoadBearingWall.scrollID, anchor: .top) }
        
        let newEntity = BrickLoadBearingWall(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.size1 = 0
        newEntity.size2 = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct BrickLoadBearingWallEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<BrickLoadBearingWall>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    private var objectCount: Int
    
    init(brickLoadBearingWall: BrickLoadBearingWall, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = BrickLoadBearingWall.fetchRequest()
        
        let cUUID = brickLoadBearingWall.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BrickLoadBearingWall.size1, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(spacing: 0) {
                    
                    Image(systemName: "ruler")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.brandBlack)
                        .rotationEffect(.degrees(90))
                        .padding(.trailing, -3)
                    
                    Text("Wall no. \(objectCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteBrickLayingOfLoadBearingWall(toDelete: fetchedEntity)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                            .frame(width: 33, height: 33)
                            .background(Color.brandGray)
                            .clipShape(Circle())
                    }
                    
                }
                
                VStack {
                    
                    ValueEditingBox(title: .width, value: $width, unit: .meter)
                        .focused($focusedDimension, equals: .first)
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    ValueEditingBox(title: .height, value: $height, unit: .meter)
                        .focused($focusedDimension, equals: .second)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $height)
                
                
                HStack(spacing: 1) {
                    
                    DoorViewsForBrickLayingOfLoadBearingWall(brickLoadBearingWall: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForBrickLayingOfLoadBearingWall(brickLoadBearingWall: fetchedEntity)
                    
                }
                
                HStack(alignment: .center) {
                    
                    Text("Complementary works")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.vertical, 4)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    let works = [
                        fetchedEntity.netting,
                        fetchedEntity.penetration_one,
                        fetchedEntity.penetration_two,
                        fetchedEntity.penetration_three,
                        fetchedEntity.tiling,
                        fetchedEntity.plastering,
                        fetchedEntity.painting
                    ]
                    
                    let isAllSingle = works.allSatisfy { $0 == 1 }
                    let isAllDouble = works.allSatisfy { $0 == 2 }
                    
                    var activeLayersNextStep: Int {
                        
                        if isAllSingle {
                            return 2
                        } else if isAllDouble {
                            return 0
                        } else {
                            return 1
                        }
                        
                    }
                    
                    Button  {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isAllSingle {
                                fetchedEntity.netting = 2
                                fetchedEntity.penetration_one = 2
                                fetchedEntity.penetration_two = 2
                                fetchedEntity.penetration_three = 2
                                fetchedEntity.tiling = 2
                                fetchedEntity.plastering = 2
                                fetchedEntity.painting = 2
                            } else if isAllDouble {
                                fetchedEntity.netting = 0
                                fetchedEntity.penetration_one = 0
                                fetchedEntity.penetration_two = 0
                                fetchedEntity.penetration_three = 0
                                fetchedEntity.tiling = 0
                                fetchedEntity.plastering = 0
                                fetchedEntity.painting = 0
                            } else {
                                fetchedEntity.netting = 1
                                fetchedEntity.penetration_one = 1
                                fetchedEntity.penetration_two = 1
                                fetchedEntity.penetration_three = 1
                                fetchedEntity.tiling = 1
                                fetchedEntity.plastering = 1
                                fetchedEntity.painting = 1
                            }
                            saveAll()
                        }
                    } label: {
                        ActiveLayersIcon(activeLayers: activeLayersNextStep).padding(.trailing, 10)
                    }
                    
                }
            
                VStack(alignment: .leading, spacing: 5) {
                    
                    let activePenetrationOne = Int(fetchedEntity.penetration_one)
                    
                    ComplementaryWorksLayeredBubble(work: PenetrationCoating.self, activeLayers: activePenetrationOne) {
                        if fetchedEntity.penetration_one <= 1 { fetchedEntity.penetration_one += 1 } else { fetchedEntity.penetration_one = 0 }
                        saveAll()
                    }
                    
                    let activeNettingWall = Int(fetchedEntity.netting)
                    
                    ComplementaryWorksLayeredBubble(work: NettingWall.self, activeLayers: activeNettingWall) {
                        if fetchedEntity.netting <= 1 { fetchedEntity.netting += 1 } else { fetchedEntity.netting = 0 }
                        saveAll()
                    }
                    
                    let activePenetrationTwo = Int(fetchedEntity.penetration_two)
                    
                    ComplementaryWorksLayeredBubble(work: PenetrationCoating.self, activeLayers: activePenetrationTwo) {
                        if fetchedEntity.penetration_two <= 1 { fetchedEntity.penetration_two += 1 } else { fetchedEntity.penetration_two = 0 }
                        saveAll()
                    }
                    
                    let activeTileCeramic = Int(fetchedEntity.tiling)
                    
                    ComplementaryWorksLayeredBubble(work: TileCeramic.self, activeLayers: activeTileCeramic) {
                        if fetchedEntity.tiling <= 1 { fetchedEntity.tiling += 1 } else { fetchedEntity.tiling = 0 }
                        saveAll()
                    }
                    
                    let activePlasteringWall = Int(fetchedEntity.plastering)
                    
                    ComplementaryWorksLayeredBubble(work: PlasteringWall.self, activeLayers: activePlasteringWall) {
                        if fetchedEntity.plastering <= 1 { fetchedEntity.plastering += 1 } else { fetchedEntity.plastering = 0 }
                        saveAll()
                    }
                    
                    let activePenetrationThree = Int(fetchedEntity.penetration_three)
                    
                    ComplementaryWorksLayeredBubble(work: PenetrationCoating.self, activeLayers: activePenetrationThree) {
                        if fetchedEntity.penetration_three <= 1 { fetchedEntity.penetration_three += 1 } else { fetchedEntity.penetration_three = 0 }
                        saveAll()
                    }
                    
                    let activePainting = Int(fetchedEntity.painting)
                    
                    ComplementaryWorksLayeredBubble(work: PaintingWall.self, activeLayers: activePainting) {
                        if fetchedEntity.painting <= 1 { fetchedEntity.painting += 1 } else { fetchedEntity.painting = 0 }
                        saveAll()
                    }
                    
                }.padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteBrickLayingOfLoadBearingWall(toDelete: BrickLoadBearingWall) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = BrickLoadBearingWall.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \BrickLoadBearingWall.size2, ascending: true)]
        
        let cUUID = toDelete.cId ?? UUID()
        
        requestObjectsToDelete.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        let fetchedObjectsToDelete = try? viewContext.fetch(requestObjectsToDelete)
        
        if let objectsToDelete = fetchedObjectsToDelete {
            
            for objectToDelete in objectsToDelete {
                viewContext.delete(objectToDelete)
            }
            
            saveAll()
            
        }
        
    }
    
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
        behavioursVM.redraw()
    }
    
}

fileprivate struct DoorViewsForBrickLayingOfLoadBearingWall: View {
    
    @FetchRequest var fetchedParent: FetchedResults<BrickLoadBearingWall>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(brickLoadBearingWall: BrickLoadBearingWall) {
        
        let entityRequest = BrickLoadBearingWall.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BrickLoadBearingWall.size2, ascending: true)]
        
        let cUUID = brickLoadBearingWall.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedParent = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedParent.first {
            
            VStack {
                
                HStack {
                    
                    Text("Doors")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createDoor(to: fetchedEntity)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .padding(.trailing, 10)
                            .frame(width: 55, alignment: .trailing)
                    }
                    
                }
                
                if !fetchedEntity.associatedDoors.isEmpty {
                    ForEach(fetchedEntity.associatedDoors) { loopedObject in
                        
                        let objectCount = fetchedEntity.associatedDoors.count - (fetchedEntity.associatedDoors.firstIndex(of: loopedObject) ?? 0)
                        
                        DoorEditor(door: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.brandGray)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .padding(.trailing, 10)
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.leading, 10)
                .padding(.vertical, 10)
        }
    }
    
    private func createDoor(to brickLoadBearingWall: BrickLoadBearingWall) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = 0
        newDoor.size2 = 0
        newDoor.dateCreated = Date.now
        newDoor.inBrickLoadBearingWall = brickLoadBearingWall
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct WindowViewsForBrickLayingOfLoadBearingWall: View {
    
    @FetchRequest var fetchedParent: FetchedResults<BrickLoadBearingWall>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(brickLoadBearingWall: BrickLoadBearingWall) {
        
        let entityRequest = BrickLoadBearingWall.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BrickLoadBearingWall.size1, ascending: true)]
        
        let cUUID = brickLoadBearingWall.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedParent = FetchRequest(fetchRequest: entityRequest)
        
    }


    
    var body: some View {
        
        if let fetchedEntity = fetchedParent.first {
            
            VStack {
                
                HStack {
                    
                    Text("Windows")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                
                    Button {
                        createWindow(to: fetchedEntity)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .padding(.trailing, 10)
                            .frame(width: 55, alignment: .trailing)
                    }
                
                }
                
                if !fetchedEntity.associatedWindows.isEmpty {
                    ForEach(fetchedEntity.associatedWindows) { loopedObject in
                        
                        let objectCount = fetchedEntity.associatedWindows.count - (fetchedEntity.associatedWindows.firstIndex(of: loopedObject) ?? 0)
                        
                        WindowEditor(window: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.brandGray)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .padding(.trailing, 10)
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.leading, 10)
                .padding(.vertical, 10)
        }
    }
    
    
    private func createWindow(to brickLoadBearingWall: BrickLoadBearingWall) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size1 = 0
        newWindow.dateCreated = Date.now
        newWindow.inBrickLoadBearingWall = brickLoadBearingWall
        saveAll()
        
    }

    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
