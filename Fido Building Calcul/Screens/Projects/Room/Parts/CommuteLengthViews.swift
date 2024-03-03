//
//  CommuteLengthViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI

struct CommuteLengthViews: View {

    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @State var length = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel

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

                    Text("Cesta")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)

                    Spacer()

                    if room.commuteLength < 0.0 {
                        Button {
                            addFirstOne(to: room)
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
                            removeAll(from: room)
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
                
                if room.commuteLength >= 0.0 {
                
                    HStack(spacing: 15) {
                        
                        Text("Dĺžka cesty")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                        
                        
                        TextField("0", text: $length)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .frame(width: 65, height: 30)
                            .background(Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        
                        Text(UnitsOfMeasurment.kilometer.rawValue)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .transition(.opacity)
                    .onAppear { length = doubleToString(from: room.commuteLength) }
                    .onChange(of: length) { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                            room.commuteLength = stringToDouble(from: length)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    }
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.commuteLength < 0 ? 20 : 30, style: .continuous))
        }
    }
    
    func addFirstOne(to room: Room) {
        
        room.commuteLength = 0.0
        saveAll()
        
    }
    
    func removeAll(from room: Room) {
        
        room.commuteLength = -1.0
        saveAll()
           
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
   
}
