//
//  PlasterboardingOffsetWallViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 09/03/2024.
//

import SwiftUI

enum PlasterBoardingOffsetTypes: Int, CaseIterable {
    
    case simple = 1
    case double = 2
    
    static func readable(_ self: PlasterBoardingOffsetTypes) -> LocalizedStringKey {
        switch self {
        case .simple:
            return "Simple"
        case .double:
            return "Double"
        }
    }
    
    static func readableFromRawValue(_ self: Int64) -> LocalizedStringKey {
        switch self {
        case 1:
            return "Simple"
        case 2:
            return "Double"
        default:
            return "Partition"
        }
    }
    
    static func parse(_ i: Int?) -> PlasterBoardingOffsetTypes {
        switch i {
        case 1:
            return .simple
        case 2:
            return .double
        default:
            return .simple
        }
        
    }
    
    static func assignedImageName(_ self: PlasterBoardingOffsetTypes) -> String {
        switch self {
        case .simple:
            return "simple.layer"
        case .double:
            return "double.layer"
        }
    }
    
}

struct PlasterboardingOffsetWallViews: View {
    
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
                    
                    TitleHeading()
                    
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
                        
                        ForEach(PlasterBoardingOffsetTypes.allCases, id: \.self) { plasterType in
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                    createNewEntity(to: room, type: plasterType)
                                    isChoosingTypeOfPlasterboarding = false
                                }
                            } label: {
                                PlasterBoardingOffsetTypesBubble(plasterBoardingOffsetTypes: plasterType)
                            }
                        }
                        
                    }.padding(.horizontal, 5)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandWhite)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    
                    
                }
                
                if !room.associatedPlasterboardingOffsetWalls.isEmpty {
                    ForEach(room.associatedSimplePlasterboardingOffsetWalls) { loopedObject in
                        
                        let objectCount = room.associatedSimplePlasterboardingOffsetWalls.count - (room.associatedSimplePlasterboardingOffsetWalls.firstIndex(of: loopedObject) ?? 0)
                        
                        PlasterboardingOffsetWallEditor(plasterboardOffsetWall: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                    ForEach(room.associatedDoublePlasterboardingOffsetWalls) { loopedObject in
                        
                        let objectCount = room.associatedDoublePlasterboardingOffsetWalls.count - (room.associatedDoublePlasterboardingOffsetWalls.firstIndex(of: loopedObject) ?? 0)
                        
                        PlasterboardingOffsetWallEditor(plasterboardOffsetWall: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlasterboardingOffsetWalls.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room, type: PlasterBoardingOffsetTypes) {
        withAnimation { scrollProxy.scrollTo(PlasterboardingOffsetWall.scrollID, anchor: .top) }
        let newEntity = PlasterboardingOffsetWall(context: viewContext)
        
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

fileprivate struct TitleHeading: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(PlasterboardingOffsetWall.title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Text(PlasterboardingOffsetWall.subTitle)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.brandBlack.opacity(0.75))
                .lineLimit(1)
            
        }

    }
}


fileprivate struct PlasterBoardingOffsetTypesBubble: View {
    
    var plasterBoardingOffsetTypes: PlasterBoardingOffsetTypes
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image(PlasterBoardingOffsetTypes.assignedImageName(plasterBoardingOffsetTypes))
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            Text(PlasterBoardingOffsetTypes.readable(plasterBoardingOffsetTypes))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
        }.padding(5)
            .frame(height: 65)
            .frame(maxWidth: .infinity)
            .background(Color.brandGray)
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
        
    }
    
}

fileprivate struct PlasterboardingOffsetWallEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlasterboardingOffsetWall>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    private var objectCount: Int
    
    init(plasterboardOffsetWall: PlasterboardingOffsetWall, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = PlasterboardingOffsetWall.fetchRequest()
        
        let cUUID = plasterboardOffsetWall.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingOffsetWall.size1, ascending: true)]
        
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
                    
                    DoorViewsForPlasterboardingOffsetWall(plasterboardOffsetWall: fetchedEntity)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                    
                    WindowViewsForPlasterboardingOffsetWall(plasterboardingOffsetWall: fetchedEntity)
                    
                }
                
                HStack(alignment: .center) {
                    
                    Text("Complementary works")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.vertical, 4)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Button  {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            fetchedEntity.penetration = true
                            fetchedEntity.painting = true
                            saveAll()
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill" )
                            .font(.system(size: 18))
                            .foregroundStyle(Color.brandBlack)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                    }
                    
                }
            
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    ComplementaryWorksBubble(work: PenetrationCoating.self, isSwitchedOn: fetchedEntity.penetration) {
                        fetchedEntity.penetration.toggle()
                        saveAll()
                    }
                    
                    ComplementaryWorksBubble(work: PaintingWall.self, isSwitchedOn: fetchedEntity.painting) {
                        fetchedEntity.painting.toggle()
                        saveAll()
                    }
                    
                }.padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: PlasterboardingOffsetWall) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = PlasterboardingOffsetWall.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingOffsetWall.size2, ascending: true)]
        
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

fileprivate struct DoorViewsForPlasterboardingOffsetWall: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardingOffsetWall>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(plasterboardOffsetWall: PlasterboardingOffsetWall) {
        
        let entityRequest = PlasterboardingOffsetWall.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingOffsetWall.size2, ascending: true)]
        
        let cUUID = plasterboardOffsetWall.cId ?? UUID()
        
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
    
    private func createDoor(to plasterboardingOffsetWall: PlasterboardingOffsetWall) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = 0
        newDoor.size2 = 0
        newDoor.dateCreated = Date.now
        newDoor.inPlasterboardingOffsetWall = plasterboardingOffsetWall
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}


fileprivate struct WindowViewsForPlasterboardingOffsetWall: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardingOffsetWall>
    
    @Environment(\.managedObjectContext) var viewContext
    
    init(plasterboardingOffsetWall: PlasterboardingOffsetWall) {
        
        let entityRequest = PlasterboardingOffsetWall.fetchRequest()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingOffsetWall.size2, ascending: true)]
        
        let cUUID = plasterboardingOffsetWall.cId ?? UUID()
        
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
    
    private func createWindow(to plasterboardingOffsetWall: PlasterboardingOffsetWall) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size1 = 0
        newWindow.dateCreated = Date.now
        newWindow.inPlasterboardingOffsetWall = plasterboardingOffsetWall
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
