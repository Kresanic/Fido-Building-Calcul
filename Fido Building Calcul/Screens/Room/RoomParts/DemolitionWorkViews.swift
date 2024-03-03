//
//  DemolitionWorkViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI


struct DemolitionWorkBubble: View {

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
                    
                    Text("Búracie práce")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedDemolitions.isEmpty {
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
                
                if !room.associatedDemolitions.isEmpty {
                    ForEach(room.associatedDemolitions) { demolition in
                        DemolitionWorkEditor(demolitionWork: demolition)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedDemolitions.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createDemolitionWork(to room: Room) {
        
        let newEntity = DemolitionWork(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.hours = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteDemolitionWork(from room: Room) {
        
        let requestForDemolitions = DemolitionWork.fetchRequest()
        
        requestForDemolitions.sortDescriptors = [NSSortDescriptor(keyPath: \DemolitionWork.hours, ascending: true)]
        
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

struct DemolitionWorkEditor: View {
    
    @FetchRequest var fetchedDemolitions: FetchedResults<DemolitionWork>
    @State var newHours = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    init(demolitionWork: DemolitionWork) {
        
        let demolitionRequest = DemolitionWork.fetchRequest()
        
        let demolitionUUID = demolitionWork.cId ?? UUID()
        
        demolitionRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DemolitionWork.hours, ascending: true)]
        
        demolitionRequest.predicate = NSPredicate(format: "cId == %@", demolitionUUID as CVarArg)
        
        _fetchedDemolitions = FetchRequest(fetchRequest: demolitionRequest)
        
    }
    
    var body: some View {
        
        if let fetchedDemolition = fetchedDemolitions.first {
            
            HStack(spacing: 15) {

                Text("Dĺžka práce")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)


                TextField("0", text: $newHours)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .frame(width: 65, height: 30)
                    .keyboardType(.decimalPad)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                Text(UnitsOfMeasurment.hour.rawValue)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)

            }
            .onAppear { newHours = doubleToString(from: fetchedDemolition.hours) }
            .onChange(of: newHours) { _ in
                fetchedDemolition.hours = stringToDouble(from: newHours)
                try? viewContext.save()
                behavioursVM.forceRedrawOfRoomCalculationBill()
            }
            
        }
        
    }
    
}
