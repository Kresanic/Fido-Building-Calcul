//
//  SiliconizationViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI

struct SiliconizationViews: View {
    
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
                    
                    Text("Silikónovanie")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedSiliconization.isEmpty {
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
                
                if !room.associatedSiliconization.isEmpty {
                    ForEach(room.associatedSiliconization) { loopedObject in
                        SiliconizationEditor(siliconization: loopedObject)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedSiliconization.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createEntity(to room: Room) {
        
        let newEntity = Siliconization(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.basicMeter = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteEntity(from room: Room) {
        
        let requestForEntites = Siliconization.fetchRequest()
        
        requestForEntites.sortDescriptors = [NSSortDescriptor(keyPath: \Siliconization.basicMeter, ascending: true)]
        
        requestForEntites.predicate = NSPredicate(format: "fromRoom == %@", room)
        
        let fetchedEntities = try? viewContext.fetch(requestForEntites)
        
        if let entities = fetchedEntities {
            
            for entity in entities {
                viewContext.delete(entity)
            }
            saveAll()
        }
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct SiliconizationEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Siliconization>
    @State var basicMeter = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    init(siliconization: Siliconization) {
        
        let entityRequest = Siliconization.fetchRequest()
        
        let cUUID = siliconization.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Siliconization.basicMeter, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text("Dĺžka")
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
