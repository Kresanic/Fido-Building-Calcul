//
//  TileCeramicViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct TileCeramicViews: View {
    
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
                        
                        Text(TileCeramic.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(TileCeramic.subTitle)
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
                
                if !room.associatedTileCeramics.isEmpty {
                    ForEach(room.associatedTileCeramics) { loopedObject in
                        
                        let objectCount = room.associatedTileCeramics.count - (room.associatedTileCeramics.firstIndex(of: loopedObject) ?? 0)
                        
                        TileCeramicEditor(tileCeramic: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedTileCeramics.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        withAnimation { scrollProxy.scrollTo(TileCeramic.scrollID, anchor: .top) }
        let newEntity = TileCeramic(context: viewContext)
        
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

fileprivate struct TileCeramicEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<TileCeramic>
    @State var width = ""
    @State var length = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    init(tileCeramic: TileCeramic, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = TileCeramic.fetchRequest()
        
        let cUUID = tileCeramic.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TileCeramic.size1, ascending: true)]
        
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
                    
                    Text("Laying no. \(objectCount)")
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
                    
                    ValueEditingBox(title: .height, value: $length, unit: .meter)
                        .onAppear { length = doubleToString(from: fetchedEntity.size2) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: length) { _ in
                            fetchedEntity.size2 = stringToDouble(from: length)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $length)
                
                HStack(spacing: 1) {
                    
                    DoorViewsForTileCeramic(tileCeramic: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForTileCeramic(tileCeramic: fetchedEntity)
                    
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    ComplementaryWorksBubble(work: LargeFormatPavingAndTiling.self, isSwitchedOn: fetchedEntity.largeFormat, subTitle: true) {
                        fetchedEntity.largeFormat.toggle()
                        saveAll()
                    }
                    
                }.padding(.horizontal, 10)
                .padding(.bottom, 10)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: TileCeramic) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = TileCeramic.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \TileCeramic.size2, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            try? viewContext.save()
            behavioursVM.redraw()
        }
    }
    
}

fileprivate struct DoorViewsForTileCeramic: View {
    
    @FetchRequest var fetchedParent: FetchedResults<TileCeramic>
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(tileCeramic: TileCeramic) {
        
        let entityRequest = TileCeramic.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TileCeramic.size2, ascending: true)]
        
        let cUUID = tileCeramic.cId ?? UUID()
        
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
    
    private func createDoor(to tileCeramic: TileCeramic) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = 0
        newDoor.size2 = 0
        newDoor.dateCreated = Date.now
        newDoor.inTileCeramic = tileCeramic
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct WindowViewsForTileCeramic: View {
    
    @FetchRequest var fetchedParent: FetchedResults<TileCeramic>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(tileCeramic: TileCeramic) {
        
        let entityRequest = TileCeramic.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TileCeramic.size2, ascending: true)]
        
        let cUUID = tileCeramic.cId ?? UUID()
        
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
    
    
    private func createWindow(to tileCeramic: TileCeramic) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size1 = 0
        newWindow.dateCreated = Date.now
        newWindow.inTileCeramic = tileCeramic
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
