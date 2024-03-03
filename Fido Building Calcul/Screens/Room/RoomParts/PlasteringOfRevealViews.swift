//
//  PlasteringOfRevealViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PlasteringOfRevealViews: View {
    
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
                    
                    Text("Stierkovanie špalety")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedPlasteringOfReveal.isEmpty {
                        Button {
                            createDemolitionWork(to: room)
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
                            deleteDemolitionWork(from: room)
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
                
                if !room.associatedPlasteringOfReveal.isEmpty {
                    ForEach(room.associatedPlasteringOfReveal) { subEntity in
                        PlasteringOfRevealEditor(plasteringOfReveal: subEntity)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlasteringOfReveal.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createDemolitionWork(to room: Room) {
        
        let newEntity = PlasteringOfReveal(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.basicMeter = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteDemolitionWork(from room: Room) {
        
        let requestForDemolitions = PlasteringOfReveal.fetchRequest()
        
        requestForDemolitions.sortDescriptors = [NSSortDescriptor(keyPath: \PlasteringOfReveal.basicMeter, ascending: true)]
        
        requestForDemolitions.predicate = NSPredicate(format: "fromRoom == %@", room)
        
        let fetchedDemolitions = try? viewContext.fetch(requestForDemolitions)
        
        if let demolitions = fetchedDemolitions {
            
            for demolition in demolitions {
                viewContext.delete(demolition)
            }
            saveAll()
            
        }
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct PlasteringOfRevealEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlasteringOfReveal>
    @State var basicMeter = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    init(plasteringOfReveal: PlasteringOfReveal) {
        
        let entityRequest = PlasteringOfReveal.fetchRequest()
        
        let cUUID = plasteringOfReveal.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasteringOfReveal.basicMeter, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text("Špal.")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                
                TextField("0", text: $basicMeter)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: 65, height: 30)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(UnitsOfMeasurment.basicMeter.rawValue)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            .onAppear { basicMeter = doubleToString(from: fetchedEntity.basicMeter) }
            .onChange(of: basicMeter) { _ in
                fetchedEntity.basicMeter = stringToDouble(from: basicMeter)
                try? viewContext.save()
                behavioursVM.forceRedrawOfRoomCalculationBill()
            }
            
        }
        
    }
    
}
