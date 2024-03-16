//
//  DemolitionViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI
import CoreData

struct DemolitionBubble: View {

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
                    
                    Text(Demolition.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedDemolitions.isEmpty {
                        Button {
                            createDemolition(to: room)
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
                            deleteDemolition(from: room)
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
                .onTapGesture {  createDemolition(to: room) }
                
                if !room.associatedDemolitions.isEmpty {
                    ForEach(room.associatedDemolitions) { demolition in
                        DemolitionEditor(demolitionWork: demolition)
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
    
    func createDemolition(to room: Room) {
        
        withAnimation { scrollProxy.scrollTo(Demolition.scrollID, anchor: .top) }
        
        let newEntity = Demolition(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteDemolition(from room: Room) {
        
        dismissKeyboard()
        
        let requestForDemolitions = Demolition.fetchRequest()
        
        requestForDemolitions.sortDescriptors = [NSSortDescriptor(keyPath: \Demolition.count, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
   
}

struct DemolitionEditor: View {
    
    @FetchRequest var fetchedDemolitions: FetchedResults<Demolition>
    @State var newHours = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(demolitionWork: Demolition) {
        
        let demolitionRequest = Demolition.fetchRequest()
        
        let demolitionUUID = demolitionWork.cId ?? UUID()
        
        demolitionRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Demolition.count, ascending: true)]
        
        demolitionRequest.predicate = NSPredicate(format: "cId == %@", demolitionUUID as CVarArg)
        
        _fetchedDemolitions = FetchRequest(fetchRequest: demolitionRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedDemolitions.first {
            
            HStack(spacing: 15) {

                Text(DimensionCallout.readableSymbol(.durationOfWork))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)

                TextField("0", text: $newHours)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .focused($focusedDimension, equals: .first)
                    .multilineTextAlignment(.center)
                    .focused($focusedDimension, equals: .first)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .keyboardType(.decimalPad)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                Text(UnitsOfMeasurment.readableSymbol(Demolition.unit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .frame(width: 40, alignment: .leading)
                
            }.padding(.horizontal, 15)
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
