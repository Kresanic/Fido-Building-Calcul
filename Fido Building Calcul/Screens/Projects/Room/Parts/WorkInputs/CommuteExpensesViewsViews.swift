//
//  CommuteLengthViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI

struct CommuteExpensesViews: View {

    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @State var days = ""
    @State var length = ""
    @State var isShowingInputs = false
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    var scrollProxy: ScrollViewProxy
    @FocusState var focusedDimension: FocusedDimension?
    
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

                    Text(Commute.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)

                    Spacer()

                    if !isShowingInputs {
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

                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                .onTapGesture {  addFirstOne(to: room) }
                
                if isShowingInputs {
                    
                    VStack {
                        
                        HStack(spacing: 15) {
                            
                            Text(DimensionCallout.readableSymbol(.commuteLength))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                                .fixedSize()
                            
                            TextField("0", text: $length)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                            .focused($focusedDimension, equals: .first)
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                                .background(Color.brandGray)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                            Text(UnitsOfMeasurment.readableSymbol(.kilometer))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                                .frame(width: 40)
                            
                        }
                        
                        HStack(spacing: 15) {
                            
                            Text(DimensionCallout.readableSymbol(.durationOfWork))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                                .fixedSize()
                            
                            TextField("0", text: $days)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .multilineTextAlignment(.center)
                                .focused($focusedDimension, equals: .second)
                                .keyboardType(.numberPad)
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                                .background(Color.brandGray)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                            Text(UnitsOfMeasurment.readableSymbol(.day))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                                .frame(width: 40)
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.all, 15)
                    .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .transition(.opacity)
                    .onAppear {
                        length = doubleToString(from: room.commuteLength)
                        days = doubleToString(from: room.daysInWork)
                    }
                    .onChange(of: length) { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            room.commuteLength = stringToDouble(from: length)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    }
                    .onChange(of: days) { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            room.daysInWork = stringToDouble(from: days)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $length, size2: $days)
                    
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: isShowingInputs ? 30 : 20, style: .continuous))
                .onAppear { if room.commuteLength > 0 || room.daysInWork > 0 { isShowingInputs = true } }
        }
    }
    
    func addFirstOne(to room: Room) {
        withAnimation { focusedDimension = .first }
        withAnimation { scrollProxy.scrollTo(Commute.scrollID, anchor: .top) }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowingInputs = true }
        room.commuteLength = 0.0
        room.daysInWork = 0.0
        saveAll()
        
    }
    
    func removeAll(from room: Room) {
        
        dismissKeyboard()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowingInputs = false }
        room.commuteLength = 0.0
        room.daysInWork = 0.0
        saveAll()
           
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
   
}
