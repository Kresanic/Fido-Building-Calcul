//
//  SiliconingViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI

struct SiliconingViews: View {
    
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
                    
                    Text(Siliconing.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedSiliconings.isEmpty {
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
                    
                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                .onTapGesture {  createEntity(to: room) }
                
                if !room.associatedSiliconings.isEmpty {
                    
                    ForEach(room.associatedSiliconings) { loopedObject in
                        SiliconingEditor(siliconization: loopedObject)
                    }.frame(maxWidth: .infinity)
                        .padding(.all, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedSiliconings.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createEntity(to room: Room) {
        withAnimation { scrollProxy.scrollTo(Siliconing.scrollID, anchor: .top) }
        let newEntity = Siliconing(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteEntity(from room: Room) {
        
        dismissKeyboard()
        
        let requestForEntites = Siliconing.fetchRequest()
        
        requestForEntites.sortDescriptors = [NSSortDescriptor(keyPath: \Siliconing.count, ascending: true)]
        
        requestForEntites.predicate = NSPredicate(format: "fromRoom == %@", room)
        
        let fetchedEntities = try? viewContext.fetch(requestForEntites)
        
        if let entities = fetchedEntities {
            
            for entity in entities {
                viewContext.delete(entity)
            }
            
            saveAll()
        }
        
    }
    
    func saveAll() { withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() } }
    
}

struct SiliconingEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Siliconing>
    @State var basicMeter = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(siliconization: Siliconing) {
        
        let entityRequest = Siliconing.fetchRequest()
        
        let cUUID = siliconization.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Siliconing.count, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text(DimensionCallout.readableSymbol(.length))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .frame(width: 55, alignment: .trailing)
                
                TextField("0", text: $basicMeter)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .focused($focusedDimension, equals: .first)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(UnitsOfMeasurement.readableSymbol(Siliconing.unit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .frame(width: 40, alignment: .leading)
                
            }
            .onAppear { basicMeter = doubleToString(from: fetchedEntity.count) }
            .onChange(of: basicMeter) { _ in
                fetchedEntity.count = stringToDouble(from: basicMeter)
                try? viewContext.save()
                behavioursVM.redraw()
            }
            .task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
            .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $basicMeter)
        }
        
    }
    
}
