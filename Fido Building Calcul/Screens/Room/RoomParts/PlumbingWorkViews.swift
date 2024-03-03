//
//  PlumbingWorkViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PlumbingWorkViews: View {
    
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
                    
                    Text("Vodoinštalatérske práce")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedPlumbingWorks.isEmpty {
                        Button {
                            createPlumbingWork(to: room)
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
                            deletePlumbingWork(from: room)
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
                
                if !room.associatedPlumbingWorks.isEmpty {
                    ForEach(room.associatedPlumbingWorks) { loopedObject in
                        PlubmingWorkEditor(plumbingWork: loopedObject)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlumbingWorks.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createPlumbingWork(to room: Room) {
        
        let newEntity = PlumbingWork(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.pieces = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deletePlumbingWork(from room: Room) {
        
        let requestForPlumbings = PlumbingWork.fetchRequest()
        
        requestForPlumbings.sortDescriptors = [NSSortDescriptor(keyPath: \PlumbingWork.pieces, ascending: true)]
        
        requestForPlumbings.predicate = NSPredicate(format: "fromRoom == %@", room)
        
        let fetchedPlumbings = try? viewContext.fetch(requestForPlumbings)
        
        if let plumbings = fetchedPlumbings {
            
            for plumbing in plumbings {
                viewContext.delete(plumbing)
            }
            saveAll()
        }
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct PlubmingWorkEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlumbingWork>
    @State var newPieces = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    init(plumbingWork: PlumbingWork) {
        
        let entityRequest = PlumbingWork.fetchRequest()
        
        let cUUID = plumbingWork.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlumbingWork.pieces, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text("Počet vývodov")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("0", text: $newPieces)
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
            .onAppear { newPieces = doubleToString(from: fetchedEntity.pieces) }
            .onChange(of: newPieces) { _ in
                fetchedEntity.pieces = stringToDouble(from: newPieces)
                try? viewContext.save()
                behavioursVM.forceRedrawOfRoomCalculationBill()
            }
            
        }
        
    }
    
}
