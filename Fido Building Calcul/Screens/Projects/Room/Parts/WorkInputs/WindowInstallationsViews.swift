//
//  WindowInstallationsViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct WindowInstallationsViews: View {
    
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
                    
                    Text(WindowInstallation.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createEntity(to: room)
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
                .onTapGesture {  createEntity(to: room) }
                
                if !room.associatedWindowInstallations.isEmpty {
                    ForEach(room.associatedWindowInstallations) { loopedObject in
                        
                        let objectCount = room.associatedWindowInstallations.count - (room.associatedWindowInstallations.firstIndex(of: loopedObject) ?? 0)
                        
                        WindowInstallationEditor(windowInstallation: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedWindowInstallations.isEmpty ? 20 : 30, style: .continuous))
                
        }
    }
    
    func createEntity(to room: Room) {
        withAnimation { scrollProxy.scrollTo(WindowInstallation.scrollID, anchor: .top) }
        let newEntity = WindowInstallation(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct WindowInstallationEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<WindowInstallation>
    @State var basicMeter = ""
    @State var pricePerWindow = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    
    init(windowInstallation: WindowInstallation, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = WindowInstallation.fetchRequest()
        
        let cUUID = windowInstallation.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WindowInstallation.count, ascending: true)]
        
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
                    
                    Text("Window no. \(objectCount)")
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
                    
                    CustomWorkValueEditingBox(title: .circumference, value: $basicMeter, unit: .basicMeter)
                        .onAppear { basicMeter = doubleToString(from:  fetchedEntity.count) }
                    .focused($focusedDimension, equals: .first)
                        .onChange(of: basicMeter) { _ in
                            fetchedEntity.count = stringToDouble(from: basicMeter)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    CustomWorkPriceEditingBox(title: .price, price: $pricePerWindow, unit: .piece, isMaterial: true)
                        .onAppear { pricePerWindow = doubleToString(from: fetchedEntity.pricePerWindow) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: pricePerWindow) { _ in
                            fetchedEntity.pricePerWindow = stringToDouble(from: pricePerWindow)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $basicMeter, size2: $pricePerWindow)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: WindowInstallation) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = WindowInstallation.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \WindowInstallation.dateCreated, ascending: true)]
        
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
    }
    
}
