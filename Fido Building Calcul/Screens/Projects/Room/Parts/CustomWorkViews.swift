//
//  CustomWorkViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/08/2023.
//

import SwiftUI

enum CustomWorkUnits: String, CaseIterable {
    case basicMeter     = "bm"
    case squareMeter   = "m\u{00B2}"
    case cubicMeter     = "m\u{00B3}"
    case piece          = "ks"
    case package        = "bal."
    case hour          = "hod."
    case kilometer      = "km"
    case day            = "dní"
}

struct CustomWorkViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var newUnitOfCustomWork: CustomWorkUnits = .basicMeter
    @State var isCreatingNewCustomWork = false
    
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
                    
                    Text("Vlastná práca")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    if !isCreatingNewCustomWork {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                isCreatingNewCustomWork = true
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
                
                if isCreatingNewCustomWork {
                    
                    VStack {
                        
                        HStack(spacing: 0) {
                            
                            Image(systemName: "ruler")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.brandBlack)
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, -3)
                                .padding(.leading, 10)
                            
                            Text("Merné jednotky")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                    isCreatingNewCustomWork = false
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
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), alignment: .center, spacing: 15) {
                            ForEach(CustomWorkUnits.allCases, id: \.self) { customUnit in
                                
                                CustomWorksUnitsButton(customUnit: customUnit)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                            newUnitOfCustomWork = customUnit
                                            createNewEntity(to: room)
                                            isCreatingNewCustomWork = false
                                        }
                                    }
                                
                            }
                        }.padding(.horizontal, 15)
                            .padding(.bottom, 5)
                        
//                        ScrollView(.horizontal) {
//
//                            HStack(spacing: 12) {
//
//
//
//
//                            }
//
//                        }
                        
                    }.padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
                
                if !room.associatedCustomWorks.isEmpty {
                    ForEach(room.associatedCustomWorks) { loopedObject in
                        CustomWorksEditor(customWork: loopedObject)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedCustomWorks.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        
        let newEntity = CustomWork(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.pricePerUnit = 0
        newEntity.numberOfUnits = 0
        newEntity.title = ""
        newEntity.unit = newUnitOfCustomWork.rawValue
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct CustomWorksUnitsButton: View {
    
    var customUnit: CustomWorkUnits
    
    var body: some View {
        
        Text(customUnit.rawValue)
            .font(.system(size: 20))
            .foregroundStyle(Color.brandBlack)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 2)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
    }
}


fileprivate struct CustomWorksEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<CustomWork>
    @State var pricePerUnit = 0.0
    @State var numberOfUnits = ""
    @State var customWorkName = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    init(customWork: CustomWork) {
        
        let entityRequest = CustomWork.fetchRequest()
        
        let cUUID = customWork.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CustomWork.dateCreated, ascending: true)]
        
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
                    
                    TextField("Názov práce", text: $customWorkName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .lineLimit(1)
                        .submitLabel(.done)
                        .onChange(of: customWorkName) { _ in
                            fetchedEntity.title = customWorkName
                            try? viewContext.save()
                        }
                    
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
                    
                    CustomWorkPriceEditingBox(title: "Cena", price: $pricePerUnit, unit: CustomWorkUnits(rawValue: fetchedEntity.unit ?? "bm") ?? CustomWorkUnits.basicMeter)
                        .onAppear { pricePerUnit = fetchedEntity.pricePerUnit }
                        .onChange(of: pricePerUnit) { _ in
                            fetchedEntity.pricePerUnit = pricePerUnit
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    CustomWorkValueEditingBox(title: "Počet", value: $numberOfUnits, unit: CustomWorkUnits(rawValue: fetchedEntity.unit ?? "bm") ?? CustomWorkUnits.basicMeter)
                        .onAppear { numberOfUnits = doubleToString(from: fetchedEntity.numberOfUnits) }
                        .onChange(of: numberOfUnits) { _ in
                            fetchedEntity.numberOfUnits = stringToDouble(from: numberOfUnits)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    
                }.onAppear { customWorkName = fetchedEntity.title ?? "" }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: CustomWork) {
        
        let requestObjectsToDelete = CustomWork.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \CustomWork.dateCreated, ascending: true)]
        
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
