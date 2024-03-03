//
//  PlasterBoardCeilingViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PlasterBoardCeilingViews: View {
    
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
                    
                    Text("Sádrokartón - strop")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createPlasterboardCeiling(to: room)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22))
                            .foregroundColor(.brandBlack)
                            .frame(width: 35, height: 35)
                            .background(Color.brandWhite)
                            .clipShape(Circle())
                        
                    }
                    
                }
                
                if !room.associatedPlasterboardCeilings.isEmpty {
                        
                        ForEach(room.associatedPlasterboardCeilings) { loopedObject in
                            
                            let objectCount = room.associatedPlasterboardCeilings.count - (room.associatedPlasterboardCeilings.firstIndex(of: loopedObject) ?? 0)
                        
                            PlasterboardCeilingEditor(plasterboardCeiling: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlasterboardCeilings.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createPlasterboardCeiling(to room: Room) {
        
        let newEntity = PlasterboardCeiling(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.length = 0
        newEntity.width = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct PlasterboardCeilingEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlasterboardCeiling>
    @State var width = ""
    @State var length = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    private var objectCount: Int
    
    init(plasterboardCeiling: PlasterboardCeiling, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = PlasterboardCeiling.fetchRequest()
        
        let cUUID = plasterboardCeiling.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardCeiling.width, ascending: true)]
        
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
                    
                    Text("Sádrokartón č.\(objectCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteObjects(toDelete: fetchedEntity)
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
                
                    
                WindowViewsForPlasterboardCeiling(plasterboardCeiling: fetchedEntity)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObjects(toDelete: PlasterboardCeiling) {

        let requestObjectsToDelete = PlasterboardCeiling.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardCeiling.length, ascending: true)]

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

fileprivate struct WindowViewsForPlasterboardCeiling: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardCeiling>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(plasterboardCeiling: PlasterboardCeiling) {
        
        let entityRequest = PlasterboardCeiling.fetchRequest()

        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardCeiling.length, ascending: true)]
        
        let cUUID = plasterboardCeiling.cId ?? UUID()
        
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
                        
                    }
                    
                }
                
                if !fetchedEntity.associatedWindows.isEmpty {
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(fetchedEntity.associatedWindows) { loopedObject in
                            
                            let objectCount = fetchedEntity.associatedWindows.count - (fetchedEntity.associatedWindows.firstIndex(of: loopedObject) ?? 0)
                            
                            WindowEditor(window: loopedObject, objectCount: objectCount)
                            
                        }.frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            .transition(.opacity)
                    }
                }
                
                Spacer()
                
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        }
    }
    
    private func createWindow(to plasterboardCeiling: PlasterboardCeiling) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.height = 0
        newWindow.width = 0
        newWindow.dateCreated = Date.now
        newWindow.inPlasterboardCeiling = plasterboardCeiling
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

