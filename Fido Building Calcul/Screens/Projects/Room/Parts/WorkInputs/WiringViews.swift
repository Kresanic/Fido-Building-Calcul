//
//  WiringViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct WiringViews: View {

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
                        
                        Text(Wiring.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(Wiring.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }

                    Spacer()

                    if room.associatedWirings.isEmpty {
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

                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if room.associatedWirings.isEmpty {
                            createElectricalWork(to: room)
                        }
                    }

                if !room.associatedWirings.isEmpty {
                    ForEach(room.associatedWirings) { electricalWork in
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
                .clipShape(RoundedRectangle(cornerRadius: room.associatedWirings.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createElectricalWork(to room: Room) {
        
        withAnimation { scrollProxy.scrollTo(Wiring.scrollID, anchor: .top) }
        
        let newEntity = Wiring(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteElectricalWork(from room: Room) {
        
        dismissKeyboard()
        
        let requestForElectricals = Wiring.fetchRequest()
        
        requestForElectricals.sortDescriptors = [NSSortDescriptor(keyPath: \Wiring.count, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
   
}

struct ElectricalWorkEditor: View {
    
    @FetchRequest var fetchedElectricalWorks: FetchedResults<Wiring>
    @State var newHours = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(electricalWork: Wiring) {
        
        let electricalRequest = Wiring.fetchRequest()
        
        let electricalUUID = electricalWork.cId ?? UUID()
        
        electricalRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Wiring.count, ascending: true)]
        
        electricalRequest.predicate = NSPredicate(format: "cId == %@", electricalUUID as CVarArg)
        
        _fetchedElectricalWorks = FetchRequest(fetchRequest: electricalRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedElectricalWorks.first {
            
            HStack(spacing: 15) {

                Text(DimensionCallout.readableSymbol(.numberOfOutlets))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)


                TextField("0", text: $newHours)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                .focused($focusedDimension, equals: .first)
                    .keyboardType(.numberPad)
                    .frame(width: 65, height: 30)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(UnitsOfMeasurment.readableSymbol(Wiring.unit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)

            }
            .onAppear { newHours = doubleToString(from: fetchedEntity.count) }
            .onChange(of: newHours) { _ in
                fetchedEntity.count = stringToDouble(from: newHours)
                try? viewContext.save()
                behavioursVM.redraw()
            }
            .task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
            .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $newHours)
            
        }
        
    }
    
}
