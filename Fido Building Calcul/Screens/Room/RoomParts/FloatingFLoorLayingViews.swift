//
//  FloatingFLoorLayingViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct FloatingFLoorLayingViews: View {
    
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
                    
                    Text("Pokládka plávajúcej podlahy")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
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
                
                if !room.associatedFloatingFloorLayings.isEmpty {
                    ForEach(room.associatedFloatingFloorLayings) { loopedObject in
                        
                        let objectCount = room.associatedFloatingFloorLayings.count - (room.associatedFloatingFloorLayings.firstIndex(of: loopedObject) ?? 0)
                        
                        FloatingFloorLayingEditor(floatingFloorLaying: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedFloatingFloorLayings.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        
        let newEntity = FloatingFloorLaying(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.width = 0
        newEntity.length = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
        
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct FloatingFloorLayingEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<FloatingFloorLaying>
    @State var width = ""
    @State var length = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    
    init(floatingFloorLaying: FloatingFloorLaying, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = FloatingFloorLaying.fetchRequest()
        
        let cUUID = floatingFloorLaying.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FloatingFloorLaying.width, ascending: true)]
        
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
                    
                    Text("Pokládka č.\(objectCount)")
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
                    
                    ValueEditingBox(title: "Dĺžka", value: $length, unit: .meter)
                        .onAppear { length = doubleToString(from: fetchedEntity.length) }
                        .onChange(of: length) { _ in
                            fetchedEntity.length = stringToDouble(from: length)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: FloatingFloorLaying) {
        
        let requestObjectsToDelete = FloatingFloorLaying.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \FloatingFloorLaying.length, ascending: true)]
        
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

