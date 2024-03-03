//
//  ToolRentalViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/08/2023.
//

import SwiftUI

struct ToolRentalViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @State var length = ""
    @State var isShowing = false
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
                    
                    Text(ToolRental.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if !isShowing {
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
                    .onTapGesture {
                        if !isShowing {
                            addFirstOne(to: room)
                        }
                    }
                
                if isShowing {
                    
                    HStack(spacing: 15) {
                        
                        Text(DimensionCallout.readableSymbol(.rentalLength))
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .fixedSize()
                        
                        TextField("0", text: $length)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .focused($focusedDimension, equals: .first)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        
                        Text(UnitsOfMeasurment.readableSymbol(.hour))
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.all, 15)
                    .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .transition(.opacity)
                    .onAppear { length = doubleToString(from: room.toolRental) }
                    .onChange(of: length) { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            room.toolRental = stringToDouble(from: length)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    }
                    .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $length)                }
            
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.toolRental <= 0.0 ? 20 : 30, style: .continuous))
                .onAppear { if room.toolRental > 0 { isShowing = true } }
        }
    }
    
    func addFirstOne(to room: Room) {
        
        withAnimation { scrollProxy.scrollTo(ToolRental.scrollID, anchor: .top)
            focusedDimension = .first}
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowing = true }
        room.toolRental = 0.0
        saveAll()
        
    }
    
    func removeAll(from room: Room) {
        dismissKeyboard()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowing = false }
        room.toolRental = 0.0
        saveAll()
        
    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
