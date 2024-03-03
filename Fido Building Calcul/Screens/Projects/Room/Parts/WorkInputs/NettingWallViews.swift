//
//  NettingWallViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct NettingWallViews: View {
    
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
                        
                        Text(NettingWall.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(NettingWall.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        createNewEntity(to: room)
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
                .onTapGesture {  createNewEntity(to: room) }
                
                if !room.associatedNettingWalls.isEmpty {
                    ForEach(room.associatedNettingWalls) { loopedObject in
                        
                        let objectCount = room.associatedNettingWalls.count - (room.associatedNettingWalls.firstIndex(of: loopedObject) ?? 0)
                        
                        NettingWallEditor(nettingWall: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedNettingWalls.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        withAnimation { scrollProxy.scrollTo(NettingWall.scrollID, anchor: .top) }
        let newEntity = NettingWall(context: viewContext)
        
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

fileprivate struct NettingWallEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<NettingWall>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    init(nettingWall: NettingWall, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = NettingWall.fetchRequest()
        
        let cUUID = nettingWall.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \NettingWall.size1, ascending: true)]
        
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
                        deleteObject(toDelete: fetchedEntity)
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
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                    .focused($focusedDimension, equals: .first)
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    ValueEditingBox(title: .height, value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $height)
                
                HStack(spacing: 1) {
                    
                    DoorViewsForNettingWall(nettingWall: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForNettingWall(nettingWall: fetchedEntity)
                    
                    
                }
                
                HStack(alignment: .center) {
                    
                    Text("Complementary works")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.vertical, 4)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Button  {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            fetchedEntity.penetration_one = true
                            fetchedEntity.penetration_two = true
                            fetchedEntity.tiling = true
                            fetchedEntity.plastering = true
                            fetchedEntity.painting = true
                            saveAll()
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill" )
                            .font(.system(size: 18))
                            .foregroundStyle(Color.brandBlack)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                    }
                    
                }
            
                VStack(alignment: .leading, spacing: 5) {
                    
                    ComplementaryWorksBubble(work: PenetrationCoating.self, isSwitchedOn: fetchedEntity.penetration_one) {
                        fetchedEntity.penetration_one.toggle()
                        saveAll()
                    }
                    
                    ComplementaryWorksBubble(work: TileCeramic.self, isSwitchedOn: fetchedEntity.tiling) {
                        fetchedEntity.tiling.toggle()
                        saveAll()
                    }
                    
                    ComplementaryWorksBubble(work: PlasteringWall.self, isSwitchedOn: fetchedEntity.plastering) {
                        fetchedEntity.plastering.toggle()
                        saveAll()
                    }
                    
                    ComplementaryWorksBubble(work: PenetrationCoating.self, isSwitchedOn: fetchedEntity.penetration_two) {
                        fetchedEntity.penetration_two.toggle()
                        saveAll()
                    }
                    
                    ComplementaryWorksBubble(work: PaintingWall.self, isSwitchedOn: fetchedEntity.painting) {
                        fetchedEntity.painting.toggle()
                        saveAll()
                    }
                    
                }.padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: NettingWall) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = NettingWall.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \NettingWall.size2, ascending: true)]
        
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

fileprivate struct DoorViewsForNettingWall: View {
    
    @FetchRequest var fetchedParent: FetchedResults<NettingWall>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(nettingWall: NettingWall) {
        
        let entityRequest = NettingWall.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \NettingWall.size2, ascending: true)]
        
        let cUUID = nettingWall.cId ?? UUID()
        
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
    
    private func createDoor(to nettingWall: NettingWall) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = 0
        newDoor.size2 = 0
        newDoor.dateCreated = Date.now
        newDoor.inNettingWall = nettingWall
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct WindowViewsForNettingWall: View {
    
    @FetchRequest var fetchedParent: FetchedResults<NettingWall>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(nettingWall: NettingWall) {
        
        let entityRequest = NettingWall.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \NettingWall.size2, ascending: true)]
        
        let cUUID = nettingWall.cId ?? UUID()
        
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
    
    private func createWindow(to nettingWall: NettingWall) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size1 = 0
        newWindow.dateCreated = Date.now
        newWindow.inNettingWall = nettingWall
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
