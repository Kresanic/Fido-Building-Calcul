//
//  PlasterboardPartitionViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PlasterboardPartitionViews: View {
    
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Sádrokartón")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text("priečka")
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
                    
                }
                
                if !room.associatedPlasterboardPartitions.isEmpty {
                    ForEach(room.associatedPlasterboardPartitions) { loopedObject in
                        
                        let objectCount = room.associatedPlasterboardPartitions.count - (room.associatedPlasterboardPartitions.firstIndex(of: loopedObject) ?? 0)
                        
                        PlasterboardPartitionEditor(plasterboardPartition: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlasterboardPartitions.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        
        let newEntity = PlasterboardPartition(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.width = 0
        newEntity.height = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct PlasterboardPartitionEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlasterboardPartition>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    private var objectCount: Int
    
    init(plasterboardPartition: PlasterboardPartition, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = PlasterboardPartition.fetchRequest()
        
        let cUUID = plasterboardPartition.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardPartition.width, ascending: true)]
        
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
                    
                    ValueEditingBox(title: "Šírka", value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.width) }
                        .onChange(of: width) { _ in
                            fetchedEntity.width = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    ValueEditingBox(title: "Výška", value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.height) }
                        .onChange(of: height) { _ in
                            fetchedEntity.height = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                }
                
                HStack(spacing: 1) {
                    
                    DoorViewsForPlasterboardPartition(plasterboardPartition: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForPlasterboardPartition(plasterboardPartition: fetchedEntity)
                    
                    
                }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: PlasterboardPartition) {
        
        let requestObjectsToDelete = PlasterboardPartition.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardPartition.height, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct DoorViewsForPlasterboardPartition: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardPartition>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(plasterboardPartition: PlasterboardPartition) {
        
        let entityRequest = PlasterboardPartition.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardPartition.height, ascending: true)]
        
        let cUUID = plasterboardPartition.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedParent = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedParent.first {
            
            VStack {
                
                HStack {
                    
                    Text("Dvere")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createDoor(to: fetchedEntity)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .frame(width: 35, alignment: .trailing)
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
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
    }
    
    private func createDoor(to plasterboardPartition: PlasterboardPartition) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.height = 0
        newDoor.width = 0
        newDoor.dateCreated = Date.now
        newDoor.inPlasterboardPartition = plasterboardPartition
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct WindowViewsForPlasterboardPartition: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardPartition>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(plasterboardPartition: PlasterboardPartition) {
        
        let entityRequest = PlasterboardPartition.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardPartition.height, ascending: true)]
        
        let cUUID = plasterboardPartition.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedParent = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    
    
    var body: some View {
        
        if let fetchedEntity = fetchedParent.first {
            
            VStack {
                
                HStack {
                    
                    Text("Okná")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createWindow(to: fetchedEntity)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .frame(width: 35, alignment: .trailing)
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
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
    }
    
    
    private func createWindow(to plasterboardPartition: PlasterboardPartition) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.height = 0
        newWindow.width = 0
        newWindow.dateCreated = Date.now
        newWindow.inPlasterboardPartition = plasterboardPartition
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
