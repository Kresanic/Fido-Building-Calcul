//
//  PlumbingViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PlumbingViews: View {
    
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
                        
                        Text(Plumbing.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(Plumbing.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                    Spacer()
                    
                    if room.associatedPlumbings.isEmpty {
                        Button {
                            createPlumbing(to: room)
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
                            deletePlumbing(from: room)
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
                .onTapGesture {  createPlumbing(to: room) }
                
                if !room.associatedPlumbings.isEmpty {
                    ForEach(room.associatedPlumbings) { loopedObject in
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
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlumbings.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createPlumbing(to room: Room) {
        withAnimation { scrollProxy.scrollTo(Plumbing.scrollID, anchor: .top) }
        let newEntity = Plumbing(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deletePlumbing(from room: Room) {
        
        dismissKeyboard()
        
        let requestForPlumbings = Plumbing.fetchRequest()
        
        requestForPlumbings.sortDescriptors = [NSSortDescriptor(keyPath: \Plumbing.count, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct PlubmingWorkEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Plumbing>
    @State var newPieces = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(plumbingWork: Plumbing) {
        
        let entityRequest = Plumbing.fetchRequest()
        
        let cUUID = plumbingWork.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Plumbing.count, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text(DimensionCallout.readableSymbol(.numberOfOutlets))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("0", text: $newPieces)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .focused($focusedDimension, equals: .first)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: 65, height: 30)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(UnitsOfMeasurment.readableSymbol(Plumbing.unit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            .onAppear { newPieces = doubleToString(from: fetchedEntity.count) }
            .onChange(of: newPieces) { _ in
                fetchedEntity.count = stringToDouble(from: newPieces)
                try? viewContext.save()
                behavioursVM.redraw()
            }
            .task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
            .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $newPieces)
            
        }
        
    }
    
}
