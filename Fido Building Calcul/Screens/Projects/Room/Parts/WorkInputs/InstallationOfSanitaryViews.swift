//
//  InstallationOfSanitaryViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

enum SanitaryTypes: String, CaseIterable {
    
    case cornerValve, standFaucet, wallFaucet, concealedFaucet, combiToilet, concealedToilet, sink, sinkWithCabinet, bathtub, shower, installationOfGutter, urinal, bathScreen, mirror
    
    static func readableSymbol(_ self: Self) -> LocalizedStringKey {
        switch self {
        case .cornerValve:
            "Corner valve"
        case .standFaucet:
            "Standing mixer tap"
        case .wallFaucet:
            "Wall-mounted tap"
        case .concealedFaucet:
            "Flush-mounted tap"
        case .combiToilet:
            "Toilet combi"
        case .concealedToilet:
            "Concealed toilet"
        case .sink:
            "Sink"
        case .sinkWithCabinet:
            "Sink with cabinet"
        case .bathtub:
            "Bathtub"
        case .shower:
            "Shower cubicle"
        case .installationOfGutter:
            "Installation of gutter"
        case .urinal:
            "Urinal"
        case .bathScreen:
            "Bath screen"
        case .mirror:
            "Mirror"
        }
        
    }
    
    static func parseAndReadable(_ s: String?) -> LocalizedStringKey {
        return readableSymbol(parse(s))
    }
    
    static func parse(_ s: String?) -> SanitaryTypes {
        switch s {
        case "cornerValve":
            return .cornerValve
        case "standFaucet":
            return .standFaucet
        case "wallFaucet":
            return .wallFaucet
        case "concealedFaucet":
            return .concealedFaucet
        case "combiToilet":
            return .combiToilet
        case "concealedToilet":
            return .concealedToilet
        case "sink":
            return .sink
        case "sinkWithCabinet":
            return .sinkWithCabinet
        case "bathtub":
            return .bathtub
        case "shower":
            return .shower
        case "installationOfGutter":
            return .installationOfGutter
        case "urinal":
            return .urinal
        case "bathScreen":
            return .bathScreen
        case "mirror":
            return .mirror
        default:
            return .cornerValve
        }
    }
    
}

struct InstallationOfSanitaryViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var newTypeOfSanitary: SanitaryTypes = .cornerValve
    @State var isCreatingNewSanitaryType = false
    var scrollProxy: ScrollViewProxy
    
    init(room: Room, scrollProxy: ScrollViewProxy) {
        
        self.scrollProxy = scrollProxy
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
                    
                    Text(InstallationOfSanitary.generalTitle)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    if !isCreatingNewSanitaryType {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
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
                    
                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                .onTapGesture {  
                    if !isCreatingNewSanitaryType {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            isCreatingNewSanitaryType = true
                        }
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
                            
                            Text("Type of sanity")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
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
                                
                                Text(SanitaryTypes.readableSymbol(sanitaryType))
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 5)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(Color.brandGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
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
                
                if !room.associatedInstallationOfSanitaries.isEmpty {
                    ForEach(room.associatedInstallationOfSanitaries) { loopedObject in
                        InstallationOfSanitaryEditor(installationOfSanitaryWare: loopedObject)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedInstallationOfSanitaries.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        
        withAnimation { scrollProxy.scrollTo(InstallationOfSanitary.generalTitle.stringKey, anchor: .top) }
        
        let newEntity = InstallationOfSanitary(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.type = newTypeOfSanitary.rawValue
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct InstallationOfSanitaryEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<InstallationOfSanitary>
    @State var pieces = ""
    @State var pricePerPiece = ""
    @State var sanitaryWareType: LocalizedStringKey = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    init(installationOfSanitaryWare: InstallationOfSanitary) {
        
        let entityRequest = InstallationOfSanitary.fetchRequest()
        
        let cUUID = installationOfSanitaryWare.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfSanitary.dateCreated, ascending: true)]
        
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
                    
                    CustomWorkValueEditingBox(title: .count, value: $pieces, unit: .piece)
                        .onAppear { pieces = doubleToString(from: fetchedEntity.count) }
                        .focused($focusedDimension, equals: .first)
                        .onChange(of: pieces) { _ in
                            fetchedEntity.count = stringToDouble(from: pieces)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    CustomWorkPriceEditingBox(title: .price, price: $pricePerPiece, unit: .piece, isMaterial: true)
                        .onAppear { pricePerPiece = doubleToString(from: fetchedEntity.pricePerSanitary) }
                        .focused($focusedDimension, equals: .second)
                        .onChange(of: pricePerPiece) { _ in
                            fetchedEntity.pricePerSanitary = stringToDouble(from: pricePerPiece)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    
                }.onAppear { sanitaryWareType = SanitaryTypes.parseAndReadable(fetchedEntity.type) }
                    .task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $pieces, size2: $pricePerPiece)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: InstallationOfSanitary) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = InstallationOfSanitary.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \InstallationOfSanitary.dateCreated, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
