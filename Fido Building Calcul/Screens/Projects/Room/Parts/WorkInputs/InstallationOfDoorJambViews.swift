//
//  InstallationOfDoorJambViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct InstallationOfDoorJambViews: View {
    
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
                    
                    Text(InstallationOfDoorJamb.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedInstallationOfDoorJambss.isEmpty {
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
                    } else {
                        Button {
                            deleteEntity(from: room)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(.brandBlack)
                                .frame(width: 35, height: 35)
                                .background(Color.brandWhite)
                                .clipShape(Circle())
                        }
                        
                        
                    }
                    
                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                .onTapGesture {  createEntity(to: room) }
                
                if !room.associatedInstallationOfDoorJambss.isEmpty {
                    ForEach(room.associatedInstallationOfDoorJambss) { subEntity in
                        InstallationOfDoorJambEditor(installationOfLinedDoorFrame: subEntity)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedInstallationOfDoorJambss.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createEntity(to room: Room) {
        withAnimation { scrollProxy.scrollTo(InstallationOfDoorJamb.scrollID, anchor: .top) }
        
        let newEntity = InstallationOfDoorJamb(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteEntity(from room: Room) {
        
        dismissKeyboard()
        
        let requestForDeletion = InstallationOfDoorJamb.fetchRequest()
        
        requestForDeletion.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfDoorJamb.count, ascending: true)]
        
        requestForDeletion.predicate = NSPredicate(format: "fromRoom == %@", room)
        
        let fetchedForDeletion = try? viewContext.fetch(requestForDeletion)
        
        if let deletions = fetchedForDeletion {
            
            for deletion in deletions {
                viewContext.delete(deletion)
            }
            saveAll()
            
        }
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct InstallationOfDoorJambEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<InstallationOfDoorJamb>
    @State var pieces = ""
    @State var pricePerPiece = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(installationOfLinedDoorFrame: InstallationOfDoorJamb) {
        
        let entityRequest = InstallationOfDoorJamb.fetchRequest()
        
        let cUUID = installationOfLinedDoorFrame.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfDoorJamb.count, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                CustomWorkValueEditingBox(title: .count, value: $pieces, unit: .piece)
                    .onAppear { pieces = doubleToString(from: fetchedEntity.count) }
                .focused($focusedDimension, equals: .first)
                    .onChange(of: pieces) { _ in
                        fetchedEntity.count = stringToDouble(from: pieces)
                        try? viewContext.save()
                        behavioursVM.redraw()
                    }
                
                CustomWorkPriceEditingBox(title: .price, price: $pricePerPiece, unit: .piece, isMaterial: true)
                    .onAppear { pricePerPiece = doubleToString(from: fetchedEntity.pricePerDoorJamb) }
                .focused($focusedDimension, equals: .second)
                    .onChange(of: pricePerPiece) { _ in
                        fetchedEntity.pricePerDoorJamb = stringToDouble(from: pricePerPiece)
                        try? viewContext.save()
                        behavioursVM.redraw()
                    }
                
            }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                .workInputsToolbar(focusedDimension: $focusedDimension, size1: $pieces, size2: $pricePerPiece)
                .padding(.horizontal, 10)
        }
        
    }
    
}
