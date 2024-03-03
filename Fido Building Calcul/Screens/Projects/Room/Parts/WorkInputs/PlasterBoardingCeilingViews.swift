//
//  PlasterBoardCeilingViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PlasterBoardCeilingViews: View {
    
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
                        
                        Text(PlasterboardingCeiling.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(PlasterboardingCeiling.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        createPlasterboardingCeiling(to: room)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22))
                            .foregroundColor(.brandBlack)
                            .frame(width: 35, height: 35)
                            .background(Color.brandWhite)
                            .clipShape(Circle())
                        
                    }
                    
                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                .onTapGesture {  createPlasterboardingCeiling(to: room) }
                
                if !room.associatedPlasterboardingCeilings.isEmpty {
                        
                        ForEach(room.associatedPlasterboardingCeilings) { loopedObject in
                            
                            let objectCount = room.associatedPlasterboardingCeilings.count - (room.associatedPlasterboardingCeilings.firstIndex(of: loopedObject) ?? 0)
                        
                            PlasterboardingCeilingEditor(plasterboardCeiling: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPlasterboardingCeilings.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createPlasterboardingCeiling(to room: Room) {
        withAnimation { scrollProxy.scrollTo(PlasterboardingCeiling.scrollID, anchor: .top) }
        let newEntity = PlasterboardingCeiling(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.size1 = 0
        newEntity.size2 = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

fileprivate struct PlasterboardingCeilingEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PlasterboardingCeiling>
    @State var width = ""
    @State var length = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    
    private var objectCount: Int
    
    init(plasterboardCeiling: PlasterboardingCeiling, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = PlasterboardingCeiling.fetchRequest()
        
        let cUUID = plasterboardCeiling.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingCeiling.size1, ascending: true)]
        
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
                    
                    Text("Plasterboarding no. \(objectCount)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteObjects(toDelete: fetchedEntity)
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
                    
                    ValueEditingBox(title: .length, value: $length, unit: .meter)
                        .onAppear { length = doubleToString(from: fetchedEntity.size2) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: length) { _ in
                            fetchedEntity.size2 = stringToDouble(from: length)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $length)
                
                    
                WindowViewsForPlasterboardingCeiling(plasterboardCeiling: fetchedEntity)
                
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
    
    private func deleteObjects(toDelete: PlasterboardingCeiling) {

        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = PlasterboardingCeiling.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingCeiling.size1, ascending: true)]

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

fileprivate struct WindowViewsForPlasterboardingCeiling: View {
    
    @FetchRequest var fetchedParent: FetchedResults<PlasterboardingCeiling>
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    init(plasterboardCeiling: PlasterboardingCeiling) {
        
        let entityRequest = PlasterboardingCeiling.fetchRequest()

        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PlasterboardingCeiling.size1, ascending: true)]
        
        let cUUID = plasterboardCeiling.cId ?? UUID()
        
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
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
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
                }
                
                Spacer()
                
            }.padding(.leading, 10)
                .padding(.vertical, 10)
        }
    }
    
    private func createWindow(to plasterboardCeiling: PlasterboardingCeiling) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = 0
        newWindow.size1 = 0
        newWindow.dateCreated = Date.now
        newWindow.inPlasterboardingCeiling = plasterboardCeiling
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

