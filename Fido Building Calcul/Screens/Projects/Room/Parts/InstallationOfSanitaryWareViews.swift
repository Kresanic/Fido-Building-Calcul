//
//  InstallationOfSanitaryWareViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

enum SanitaryTypes: String, CaseIterable {
    case cornerValve = "Rohový ventil"
    case standFaucet = "Batéria stojanová"
    case wallFaucet = "Batéria nástenná"
    case concealedFaucet = "Batéria podomietková"
    case combiToilet = "WC kombi"
    case concealedToilet = "WC podomietkové"
    case sink = "Umývadlo"
    case sinkWithCabinet = "Umývadlo so skrinkou"
    case bathtub = "Vaňa"
    case shower = "Sprchový kút"
    case installationOfGutter = "Osadenie žľabu"
}

struct InstallationOfSanitaryWareViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var newTypeOfSanitary: SanitaryTypes = .cornerValve
    @State var isCreatingNewSanitaryType = false
    
    init(room: Room) {
        
        let roomRequest = Room.fetchRequest()
        
        roomRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.dateCreated, ascending: true)]
        
        let cUUID = room.cId ?? UUID()
        
        roomRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedRoom = FetchRequest(fetchRequest: roomRequest)
        
    }
    
    var body: some View {
        
        if let room = fetchedRoom.first {
            
            VStack {
                
                HStack {
                    
                    Text("Osadenie sanity")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    if !isCreatingNewSanitaryType {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                isCreatingNewSanitaryType = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 22))
                                .foregroundColor(.brandBlack)
                                .frame(width: 35, height: 35)
                                .background(Color.brandWhite)
                                .clipShape(Circle())
                            
                        }
                        .transition(.scale)
                    }
                    
                }
                
                if isCreatingNewSanitaryType {
                    
                    VStack {
                        
                        HStack(spacing: 0) {
                            
                            Image(systemName: "ruler")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.brandBlack)
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, -3)
                                .padding(.leading, 10)
                            
                            Text("Typ sanity")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                    isCreatingNewSanitaryType = false
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                    .foregroundColor(.brandBlack)
                                    .frame(width: 33, height: 33)
                                    .background(Color.brandGray)
                                    .clipShape(Circle())
                            }.padding(.trailing, 10)
                            
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .center, spacing: 15) {
                            
                            ForEach(SanitaryTypes.allCases, id: \.self) { sanitaryType in
                                
                                Text(sanitaryType.rawValue)
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.brandBlack)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 3)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(Color.brandGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                            newTypeOfSanitary = sanitaryType
                                            createNewEntity(to: room)
                                            isCreatingNewSanitaryType = false
                                        }
                                    }
                                
                            }
                        }.padding(.horizontal, 15)
                            .padding(.bottom, 5)
                        
                    }.padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                }
                
                if !room.associatedInstallationOfSanitaryWares.isEmpty {
                    ForEach(room.associatedInstallationOfSanitaryWares) { loopedObject in
                        InstallationOfSanitaryWareEditor(installationOfSanitaryWare: loopedObject)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedInstallationOfSanitaryWares.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        
        let newEntity = InstallationOfSanitaryWare(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.type = newTypeOfSanitary.rawValue
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct InstallationOfSanitaryWareEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<InstallationOfSanitaryWare>
    @State var pieces = ""
    @State var sanitaryWareType = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    init(installationOfSanitaryWare: InstallationOfSanitaryWare) {
        
        let entityRequest = InstallationOfSanitaryWare.fetchRequest()
        
        let cUUID = installationOfSanitaryWare.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfSanitaryWare.dateCreated, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(spacing: 0) {
                    
                    Image(systemName: "ruler")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.brandBlack)
                        .rotationEffect(.degrees(90))
                        .padding(.trailing, -3)
                    
                    Text(sanitaryWareType)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
//                    TextField("Názov práce", text: $customWorkName)
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundStyle(Color.brandBlack)
//                        .lineLimit(1)
//                        .submitLabel(.done)
//                        .onChange(of: customWorkName) { _ in
//                            fetchedEntity.name = customWorkName
//                            try? viewContext.save()
//                        }
                    
                    Spacer()
                    
                    
                    Button {
                        deleteObject(toDelete: fetchedEntity)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                            .frame(width: 33, height: 33)
                            .background(Color.brandGray)
                            .clipShape(Circle())
                    }
                    
                }
                
                VStack {
                    
                    CustomWorkValueEditingBox(title: "Počet", value: $pieces, unit: .piece)
                        .onAppear { pieces = doubleToString(from: fetchedEntity.pieces) }
                        .onChange(of: pieces) { _ in
                            fetchedEntity.pieces = stringToDouble(from: pieces)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    
                }.onAppear { sanitaryWareType = fetchedEntity.type ?? "Sanita" }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: InstallationOfSanitaryWare) {
        
        let requestObjectsToDelete = InstallationOfSanitaryWare.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfSanitaryWare.dateCreated, ascending: true)]
        
        let cUUID = toDelete.cId ?? UUID()
        
        requestObjectsToDelete.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        let fetchedObjectsToDelete = try? viewContext.fetch(requestObjectsToDelete)
        
        if let objectsToDelete = fetchedObjectsToDelete {
            
            for objectToDelete in objectsToDelete {
                viewContext.delete(objectToDelete)
            }
            saveAll()
        }
        
    }
    
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
