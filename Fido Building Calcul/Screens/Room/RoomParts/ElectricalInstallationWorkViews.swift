//
//  ElectricalInstallationWorkViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct ElectricalInstallationWorkViews: View {

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

                    Text("Elektroinštalatérske práce")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)

                    Spacer()

                    if room.associatedElectricalWorks.isEmpty {
                        Button {
                            createElectricalWork(to: room)
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
                            deleteElectricalWork(from: room)
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

                if !room.associatedElectricalWorks.isEmpty {
                    ForEach(room.associatedElectricalWorks) { electricalWork in
                        ElectricalWorkEditor(electricalWork: electricalWork)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }

            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedElectricalWorks.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createElectricalWork(to room: Room) {
        
        let newEntity = ElectricalInstallationWork(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.hours = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteElectricalWork(from room: Room) {
        
        let requestForElectricals = ElectricalInstallationWork.fetchRequest()
        
        requestForElectricals.sortDescriptors = [NSSortDescriptor(keyPath: \ElectricalInstallationWork.hours, ascending: true)]
        
        requestForElectricals.predicate = NSPredicate(format: "fromRoom == %@", room)
        
        let fetchedElectricals = try? viewContext.fetch(requestForElectricals)
        
        if let electricals = fetchedElectricals {
            
            for electrical in electricals {
                viewContext.delete(electrical)
            }
            saveAll()
            
        }
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
   
}

struct ElectricalWorkEditor: View {
    
    @FetchRequest var fetchedElectricalWorks: FetchedResults<ElectricalInstallationWork>
    @State var newHours = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    init(electricalWork: ElectricalInstallationWork) {
        
        let electricalRequest = ElectricalInstallationWork.fetchRequest()
        
        let electricalUUID = electricalWork.cId ?? UUID()
        
        electricalRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ElectricalInstallationWork.hours, ascending: true)]
        
        electricalRequest.predicate = NSPredicate(format: "cId == %@", electricalUUID as CVarArg)
        
        _fetchedElectricalWorks = FetchRequest(fetchRequest: electricalRequest)
        
    }
    
    var body: some View {
        
        if let fetchedElectricalWorks = fetchedElectricalWorks.first {
            
            HStack(spacing: 15) {

                Text("Počet vývodov")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)


                TextField("0", text: $newHours)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .frame(width: 65, height: 30)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(UnitsOfMeasurment.piece.rawValue)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)

            }
            .onAppear { newHours = doubleToString(from: fetchedElectricalWorks.hours) }
            .onChange(of: newHours) { _ in
                fetchedElectricalWorks.hours = stringToDouble(from: newHours)
                try? viewContext.save()
                behavioursVM.forceRedrawOfRoomCalculationBill()
            }
            
        }
        
    }
    
}
