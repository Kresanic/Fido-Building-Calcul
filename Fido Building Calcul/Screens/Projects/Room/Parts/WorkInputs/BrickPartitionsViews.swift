//
//  BrickLayingOfPartitionsViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct BrickLayingOfPartitionsViews: View {
    
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
                        
                        Text(BrickPartition.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(BrickPartition.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                    Spacer()
                
                    Button {
                        createBrickLayingOfPartitions(to: room)
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
                .onTapGesture {  createBrickLayingOfPartitions(to: room) }
                
                if !room.associatedBrickPartitions.isEmpty {
                    ForEach(room.associatedBrickPartitions) { loopedObject in
                        
                        let objectCount = room.associatedBrickPartitions.count - (room.associatedBrickPartitions.firstIndex(of: loopedObject) ?? 0)
                        
                        BrickLayingOfPartitionsEditor(brickPartition: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedBrickPartitions.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    private func createBrickLayingOfPartitions(to room: Room) {
        
        withAnimation { scrollProxy.scrollTo(BrickPartition.scrollID, anchor: .top) }
        
        let newEntity = BrickPartition(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.size1 = 0
        newEntity.size2 = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }

    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct BrickLayingOfPartitionsEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<BrickPartition>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    var objectCount: Int
    
    init(brickPartition: BrickPartition, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = BrickPartition.fetchRequest()
        
        let cUUID = brickPartition.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BrickPartition.size1, ascending: true)]
        
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
                    
                    Text("Partition no. \(objectCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteBrickLayingOfPartitions(toDelete: fetchedEntity)
                        dismissKeyboard()
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
                        .onAppear { height = doubleToString(from: fetchedEntity.size2)}
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $height)
                
                HStack(spacing: 1) {
                    
                    DoorViewsForBrickPartition(brickLayingOfPartitions: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForBrickPartition(brickLayingOfPartitions: fetchedEntity)
                    
                    
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
    
    func deleteBrickLayingOfPartitions(toDelete: BrickPartition) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = BrickPartition.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \BrickPartition.size2, ascending: true)]

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
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
        behavioursVM.redraw()
    }
    
}

fileprivate struct DoorViewsForBrickPartition: View {
    
    @FetchRequest var fetchedBrickLayingOfPartition: FetchedResults<BrickPartition>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(brickLayingOfPartitions: BrickPartition) {
        
        let entityRequest = BrickPartition.fetchRequest()

        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BrickPartition.size2, ascending: true)]
        
        let cUUID = brickLayingOfPartitions.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedBrickLayingOfPartition = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let brickLayingOfPartition = fetchedBrickLayingOfPartition.first {
            
            VStack {
                
                HStack {
                    
                    Text("Doors")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                
                    Button {
                        createDoor(to: brickLayingOfPartition)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .padding(.trailing, 10)
                            .frame(width: 55, alignment: .trailing)
                    }
                
                }
                
                if !brickLayingOfPartition.associatedDoors.isEmpty {
                    ForEach(brickLayingOfPartition.associatedDoors) { loopedObject in
                        
                        let objectCount = brickLayingOfPartition.associatedDoors.count - (brickLayingOfPartition.associatedDoors.firstIndex(of: loopedObject) ?? 0)
                        
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
    
    func createDoor(to brickLayingOfPartitions: BrickPartition) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = 0
        newDoor.size2 = 0
        newDoor.dateCreated = Date.now
        newDoor.inBrickPartition = brickLayingOfPartitions
        saveAll()
        
    }

    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}




fileprivate struct WindowViewsForBrickPartition: View {
    
    @FetchRequest var fetchedBrickLayingOfPartition: FetchedResults<BrickPartition>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(brickLayingOfPartitions: BrickPartition) {
        
        let entityRequest = BrickPartition.fetchRequest()

        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BrickPartition.size1, ascending: true)]
        
        let cUUID = brickLayingOfPartitions.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedBrickLayingOfPartition = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let brickLayingOfPartition = fetchedBrickLayingOfPartition.first {
            
            VStack {
                
                HStack {
                    
                    Text("Windows")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                
                    Button {
                        createWindow(to: brickLayingOfPartition)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .padding(.trailing, 10)
                            .frame(width: 55, alignment: .trailing)
                        
                    }
                
                }
                
                if !brickLayingOfPartition.associatedWindows.isEmpty {
                    ForEach(brickLayingOfPartition.associatedWindows) { loopedObject in
                        
                        let objectCount = brickLayingOfPartition.associatedWindows.count - (brickLayingOfPartition.associatedWindows.firstIndex(of: loopedObject) ?? 0)
                        
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
    
    func createWindow(to brickLayingOfPartitions: BrickPartition) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size2 = 0
        newWindow.dateCreated = Date.now
        newWindow.inBrickPartition = brickLayingOfPartitions
        saveAll()
        
    }

    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

