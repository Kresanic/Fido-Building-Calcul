//
//  InstallationOfSanitaryWareViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct InstallationOfSanitaryWareViews: View {
    
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
                    
                    Text("Osadenie sanity")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedInstallationOfSanitaryWiares.isEmpty {
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
                    
                }
                
                if !room.associatedInstallationOfSanitaryWiares.isEmpty {
                    ForEach(room.associatedInstallationOfSanitaryWiares) { subEntity in
                        InstallationOfSanitaryWareEditor(installationOfSanitaryWare: subEntity)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedInstallationOfSanitaryWiares.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createEntity(to room: Room) {
        
        let newEntity = InstallationOfSanitaryWare(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.pieces = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteEntity(from room: Room) {
        
        let requestForDeletion = InstallationOfSanitaryWare.fetchRequest()
        
        requestForDeletion.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfSanitaryWare.pieces, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct InstallationOfSanitaryWareEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<InstallationOfSanitaryWare>
    @State var pieces = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    init(installationOfSanitaryWare: InstallationOfSanitaryWare) {
        
        let entityRequest = InstallationOfSanitaryWare.fetchRequest()
        
        let cUUID = installationOfSanitaryWare.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfSanitaryWare.pieces, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text("Počet")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                
                TextField("0", text: $pieces)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: 65, height: 30)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(UnitsOfMeasurment.piece.rawValue)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            .onAppear { pieces = doubleToString(from: fetchedEntity.pieces) }
            .onChange(of: pieces) { _ in
                fetchedEntity.pieces = stringToDouble(from: pieces)
                try? viewContext.save()
                behavioursVM.forceRedrawOfRoomCalculationBill()
            }
            
        }
        
    }
    
}
