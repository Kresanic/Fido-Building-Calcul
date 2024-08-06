//
//  PlasterboardingPartitionViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

enum PlasterBoardingTypes: Int, CaseIterable {
    
    case simple = 1
    case double = 2
    case triple = 3
    
    static func readable(_ self: PlasterBoardingTypes) -> LocalizedStringKey {
        switch self {
        case .simple:
            return "Simple"
        case .double:
            return "Double"
        case .triple:
            return "Triple"
        }
    }
    
    static func readableFromRawValue(_ self: Int64) -> LocalizedStringKey {
        switch self {
        case 1:
            return "Simple"
        case 2:
            return "Double"
        case 3:
            return "Triple"
        default:
            return "Partition"
        }
    }
    
    static func parse(_ i: Int?) -> PlasterBoardingTypes {
        switch i {
        case 1:
            return .simple
        case 2:
            return .double
        case 3:
            return .triple
        default:
            return .simple
        }
        
    }
    
    static func assignedImageName(_ self: PlasterBoardingTypes) -> String {
        switch self {
        case .simple:
            return "simple.layer"
        case .double:
            return "double.layer"
        case .triple:
            return "triple.layer"
        }
    }
    
}

struct PlasterboardingPartitionViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @State private var isChoosingTypeOfPlasterboarding = false
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
                        
                        Text(PlasterboardingPartition.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(PlasterboardingPartition.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                    Spacer()
                    
                    if isChoosingTypeOfPlasterboarding {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                isChoosingTypeOfPlasterboarding = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 22))
                                .foregroundColor(.brandBlack)
                                .frame(width: 35, height: 35)
                                .background(Color.brandWhite)
                                .clipShape(Circle())
                        }.transition(.scale)
                    } else {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                isChoosingTypeOfPlasterboarding = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 22))
                                .foregroundColor(.brandBlack)
                                .frame(width: 35, height: 35)
                                .background(Color.brandWhite)
                                .clipShape(Circle())
                        }.transition(.scale)
                    }
                    
                }
                
                if isChoosingTypeOfPlasterboarding {
                    
                    HStack {
                        
                        ForEach(PlasterBoardingTypes.allCases, id: \.self) { plasterType in
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                    createNewEntity(to: room, type: plasterType)
                                    isChoosingTypeOfPlasterboarding = false
                                }
                            } label: {
                                PlasterBoardingTypesBubble(plasterboardingType: plasterType)
                            }
                        }
                        
                    }.padding(.horizontal, 5)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandWhite)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    
                    
                }
                
                if !room.associatedPlasterboardingPartitions.isEmpty {
                    ForEach(room.associatedSimplePlasterboardingPartitions) { loopedObject in
                        
                        let objectCount = room.associatedSimplePlasterboardingPartitions.count - (room.associatedSimplePlasterboardingPartitions.firstIndex(of: loopedObject) ?? 0)
                        
                        PlasterboardingPartitionEditor(plasterboardPartition: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                    ForEach(room.associatedDoublePlasterboardingPartitions) { loopedObject in
                        
                        let objectCount = room.associatedDoublePlasterboardingPartitions.count - (room.associatedDoublePlasterboardingPartitions.firstIndex(of: loopedObject) ?? 0)
                        
                        PlasterboardingPartitionEditor(plasterboardPartition: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                    ForEach(room.associatedTriplePlasterboardingPartitions) { loopedObject in
                        
                        let objectCount = room.associatedTriplePlasterboardingPartitions.count - (room.associatedTriplePlasterboardingPartitions.firstIndex(of: loopedObject) ?? 0)
                        
                        PlasterboardingPartitionEditor(plasterboardPartition: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlasterboardingPartitions.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room, type: PlasterBoardingTypes) {
        withAnimation { scrollProxy.scrollTo(PlasterboardingPartition.scrollID, anchor: .top) }
        let newEntity = PlasterboardingPartition(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.size1 = 0
        newEntity.size2 = 0
        newEntity.type = Int64(type.rawValue)
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct PlasterBoardingTypesBubble: View {
    
    var plasterboardingType: PlasterBoardingTypes
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image(PlasterBoardingTypes.assignedImageName(plasterboardingType))
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            Text(PlasterBoardingTypes.readable(plasterboardingType))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
        }.padding(5)
            .frame(width: 100, height: 65)
            .background(Color.brandGray)
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
        
    }
    
}

fileprivate struct PlasterboardingPartitionEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlasterboardingPartition>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    private var objectCount: Int
    
    init(plasterboardPartition: PlasterboardingPartition, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = PlasterboardingPartition.fetchRequest()
        
        let cUUID = plasterboardPartition.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingPartition.size1, ascending: true)]
        
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
                    
                    Text(PlasterBoardingTypes.readableFromRawValue(fetchedEntity.type))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.brandBlack)
                    +
                    Text(" no. \(objectCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.brandBlack)
                    
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
                    
                    ValueEditingBox(title: .width, value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                    .focused($focusedDimension, equals: .first)
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    ValueEditingBox(title: .height, value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                        .focused($focusedDimension, equals: .second)
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $height)
                
                HStack(spacing: 1) {
                    
                    DoorViewsForPlasterboardingPartition(plasterboardPartition: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForPlasterboardingPartition(plasterboardPartition: fetchedEntity)
                    
                }
                
                HStack(alignment: .center) {
                    
                    Text("Complementary works")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.vertical, 4)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    let works = [
                        fetchedEntity.penetration,
                        fetchedEntity.painting
                    ]
                    
                    let isAllSingle = works.allSatisfy { $0 == 1 }
                    let isAllDouble = works.allSatisfy { $0 == 2 }
                    
                    var activeLayersNextStep: Int {
                        
                        if isAllSingle {
                            return 2
                        } else if isAllDouble {
                            return 0
                        } else {
                            return 1
                        }
                        
                    }
                    
                    Button  {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isAllSingle {
                                fetchedEntity.penetration = 2
                                fetchedEntity.painting = 2
                            } else if isAllDouble {
                                fetchedEntity.penetration = 0
                                fetchedEntity.painting = 0
                            } else {
                                fetchedEntity.penetration = 1
                                fetchedEntity.painting = 1
                            }
                            saveAll()
                        }
                    } label: {
                        ActiveLayersIcon(activeLayers: activeLayersNextStep).padding(.trailing, 10)
                    }
                    
                }
            
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    let activePenetration = Int(fetchedEntity.penetration)
                    
                    ComplementaryWorksLayeredBubble(work: PenetrationCoating.self, activeLayers: activePenetration) {
                        if fetchedEntity.penetration <= 1 { fetchedEntity.penetration += 1 } else { fetchedEntity.penetration = 0 }
                        saveAll()
                    }
                    
                    let activePainting = Int(fetchedEntity.painting)
                    
                    ComplementaryWorksLayeredBubble(work: PaintingWall.self, activeLayers: activePainting) {
                        if fetchedEntity.painting <= 1 { fetchedEntity.painting += 1 } else { fetchedEntity.painting = 0 }
                        saveAll()
                    }
                    
                }.padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: PlasterboardingPartition) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = PlasterboardingPartition.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingPartition.size2, ascending: true)]
        
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
        behavioursVM.redraw()
    }
    
}

fileprivate struct DoorViewsForPlasterboardingPartition: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardingPartition>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(plasterboardPartition: PlasterboardingPartition) {
        
        let entityRequest = PlasterboardingPartition.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingPartition.size2, ascending: true)]
        
        let cUUID = plasterboardPartition.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedParent = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedParent.first {
            
            VStack {
                
                HStack {
                    
                    Text("Doors")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createDoor(to: fetchedEntity)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .padding(.trailing, 10)
                            .frame(width: 55, alignment: .trailing)
                    }
                    
                }
                
                if !fetchedEntity.associatedDoors.isEmpty {
                    ForEach(fetchedEntity.associatedDoors) { loopedObject in
                        
                        let objectCount = fetchedEntity.associatedDoors.count - (fetchedEntity.associatedDoors.firstIndex(of: loopedObject) ?? 0)
                        
                        DoorEditor(door: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.brandGray)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .padding(.trailing, 10)
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.leading, 10)
                .padding(.vertical, 10)
        }
    }
    
    private func createDoor(to plasterboardPartition: PlasterboardingPartition) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = 0
        newDoor.size2 = 0
        newDoor.dateCreated = Date.now
        newDoor.inPlasterboardingPartition = plasterboardPartition
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct WindowViewsForPlasterboardingPartition: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardingPartition>
    
    @Environment(\.managedObjectContext) var viewContext
    
    init(plasterboardPartition: PlasterboardingPartition) {
        
        let entityRequest = PlasterboardingPartition.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingPartition.size2, ascending: true)]
        
        let cUUID = plasterboardPartition.cId ?? UUID()
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedParent = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedParent.first {
            
            VStack {
                
                HStack {
                    
                    Text("Windows")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        createWindow(to: fetchedEntity)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.brandBlack)
                            .padding(.trailing, 10)
                            .frame(width: 55, alignment: .trailing)
                    }
                    
                }
                
                if !fetchedEntity.associatedWindows.isEmpty {
                    ForEach(fetchedEntity.associatedWindows) { loopedObject in
                        
                        let objectCount = fetchedEntity.associatedWindows.count - (fetchedEntity.associatedWindows.firstIndex(of: loopedObject) ?? 0)
                        
                        WindowEditor(window: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.brandGray)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .padding(.trailing, 10)
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.padding(.leading, 10)
                .padding(.vertical, 10)
        }
    }
    
    private func createWindow(to plasterboardPartition: PlasterboardingPartition) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size1 = 0
        newWindow.dateCreated = Date.now
        newWindow.inPlasterboardingPartition = plasterboardPartition
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
