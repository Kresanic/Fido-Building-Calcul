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
    
    init(room: Room) {
        
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
                    
                    Text("Murovanie priečok 75 - 175 mm")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
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
                
                }
                
                if !room.associatedBricklayingOfPartitions.isEmpty {
                    ForEach(room.associatedBricklayingOfPartitions) { loopedObject in
                        
                        let objectCount = room.associatedBricklayingOfPartitions.count - (room.associatedBricklayingOfPartitions.firstIndex(of: loopedObject) ?? 0)
                        
                        BrickLayingOfPartitionsEditor(bricklayingOfPartitions: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedBricklayingOfPartitions.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    private func createBrickLayingOfPartitions(to room: Room) {
        
        let newEntity = BricklayingOfPartitions(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.height = 0
        newEntity.width = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }

    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct BrickLayingOfPartitionsEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<BricklayingOfPartitions>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    var objectCount: Int
    
    init(bricklayingOfPartitions: BricklayingOfPartitions, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = BricklayingOfPartitions.fetchRequest()
        
        let cUUID = bricklayingOfPartitions.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BricklayingOfPartitions.width, ascending: true)]
        
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
                    
                    Text("Priečka č.\(objectCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteBrickLayingOfPartitions(toDelete: fetchedEntity)
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
                    
                    ValueEditingBox(title: "Šírka", value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.width)}
                        .onChange(of: width) { _ in
                            fetchedEntity.width = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    ValueEditingBox(title: "Výška", value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.height)}
                        .onChange(of: height) { _ in
                            fetchedEntity.height = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                }
                
                HStack(spacing: 1) {
                    
                    DoorViewsForBricklayingOfPartitions(brickLayingOfPartitions: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForBricklayingOfPartitions(brickLayingOfPartitions: fetchedEntity)
                    
                    
                }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    func deleteBrickLayingOfPartitions(toDelete: BricklayingOfPartitions) {

        let requestObjectsToDelete = BricklayingOfPartitions.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \BricklayingOfPartitions.height, ascending: true)]

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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct DoorViewsForBricklayingOfPartitions: View {
    
    @FetchRequest var fetchedBrickLayingOfPartition: FetchedResults<BricklayingOfPartitions>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(brickLayingOfPartitions: BricklayingOfPartitions) {
        
        let entityRequest = BricklayingOfPartitions.fetchRequest()

        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BricklayingOfPartitions.height, ascending: true)]
        
        let cUUID = brickLayingOfPartitions.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedBrickLayingOfPartition = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let brickLayingOfPartition = fetchedBrickLayingOfPartition.first {
            
            VStack {
                
                HStack {
                    
                    Text("Dvere")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                
                    Button {
                        createDoor(to: brickLayingOfPartition)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                        
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
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
    }
    
    func createDoor(to brickLayingOfPartitions: BricklayingOfPartitions) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.height = 0
        newDoor.width = 0
        newDoor.dateCreated = Date.now
        newDoor.inBricklayingOfPartitions = brickLayingOfPartitions
        saveAll()
        
    }

    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}




fileprivate struct WindowViewsForBricklayingOfPartitions: View {
    
    @FetchRequest var fetchedBrickLayingOfPartition: FetchedResults<BricklayingOfPartitions>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(brickLayingOfPartitions: BricklayingOfPartitions) {
        
        let entityRequest = BricklayingOfPartitions.fetchRequest()

        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BricklayingOfPartitions.height, ascending: true)]
        
        let cUUID = brickLayingOfPartitions.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedBrickLayingOfPartition = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let brickLayingOfPartition = fetchedBrickLayingOfPartition.first {
            
            VStack {
                
                HStack {
                    
                    Text("Okná")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                
                    Button {
                        createWindow(to: brickLayingOfPartition)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                        
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
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
    }
    
    func createWindow(to brickLayingOfPartitions: BricklayingOfPartitions) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.height = 0
        newWindow.width = 0
        newWindow.dateCreated = Date.now
        newWindow.inBricklayingOfPartitions = brickLayingOfPartitions
        saveAll()
        
    }

    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

