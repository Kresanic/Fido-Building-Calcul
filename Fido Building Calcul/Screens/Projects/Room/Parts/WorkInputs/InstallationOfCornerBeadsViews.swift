//
//  InstallationOfCornerBeadViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct InstallationOfCornerBeadViews: View {
    
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
                    
                    Text(InstallationOfCornerBead.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if room.associatedInstallationOfCornerBeads.isEmpty {
                        Button {
                            createInstallationOfCornerBeads(to: room)
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
                            deleteInstallationOfCornerBeads(from: room)
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
                .onTapGesture {  createInstallationOfCornerBeads(to: room) }
                
                if !room.associatedInstallationOfCornerBeads.isEmpty {
                    ForEach(room.associatedInstallationOfCornerBeads) { subEntity in
                        InstallationOfCornerBeadEditor(installationOfCornerStrip: subEntity)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedInstallationOfCornerBeads.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createInstallationOfCornerBeads(to room: Room) {
        withAnimation { scrollProxy.scrollTo(InstallationOfCornerBead.scrollID, anchor: .top) }
        
        let newEntity = InstallationOfCornerBead(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func deleteInstallationOfCornerBeads(from room: Room) {
        
        let requestForDemolitions = InstallationOfCornerBead.fetchRequest()
        
        requestForDemolitions.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfCornerBead.count, ascending: true)]
        
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

struct InstallationOfCornerBeadEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<InstallationOfCornerBead>
    @State var basicMeter = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(installationOfCornerStrip: InstallationOfCornerBead) {
        
        let entityRequest = InstallationOfCornerBead.fetchRequest()
        
        let cUUID = installationOfCornerStrip.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfCornerBead.count, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            HStack(spacing: 15) {
                
                Text(DimensionCallout.readableSymbol(.windowLining))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("0", text: $basicMeter)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                .focused($focusedDimension, equals: .first)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: 65, height: 30)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(UnitsOfMeasurment.readableSymbol(InstallationOfCornerBead.unit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            .onAppear { basicMeter = doubleToString(from: fetchedEntity.count) }
            .onChange(of: basicMeter) { _ in
                fetchedEntity.count = stringToDouble(from: basicMeter)
                try? viewContext.save()
                behavioursVM.redraw()
            }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $basicMeter)
            
        }
        
    }
    
}
