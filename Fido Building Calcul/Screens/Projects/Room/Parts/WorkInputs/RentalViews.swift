//
//  RentalViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/08/2023.
//

import SwiftUI

//struct ToolRentalViews: View {
//    
//    @FetchRequest var fetchedRoom: FetchedResults<Room>
//    @State var length = ""
//    @State var isShowing = false
//    @Environment(\.managedObjectContext) var viewContext
//    @EnvironmentObject var behavioursVM: BehavioursViewModel
//    var scrollProxy: ScrollViewProxy
//    @FocusState var focusedDimension: FocusedDimension?
//    
//    
//    init(room: Room, scrollProxy: ScrollViewProxy) {
//        
//        self.scrollProxy = scrollProxy
//        let roomRequest = Room.fetchRequest()
//        
//        roomRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: true)]
//        
//        let cUUID = room.cId ?? UUID()
//        
//        roomRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
//        
//        _fetchedRoom = FetchRequest(fetchRequest: roomRequest)
//        
//    }
//    
//    var body: some View {
//        
//        if let room = fetchedRoom.first {
//            
//            VStack {
//                
//                HStack {
//                    
//                    Text(ToolRental.title)
//                        .font(.system(size: 22, weight: .semibold))
//                        .foregroundStyle(Color.brandBlack)
//                    
//                    Spacer()
//                    
//                    if !isShowing {
//                        Button {
//                            addFirstOne(to: room)
//                        } label: {
//                            Image(systemName: "plus")
//                                .font(.system(size: 22))
//                                .foregroundColor(.brandBlack)
//                                .frame(width: 35, height: 35)
//                                .background(Color.brandWhite)
//                                .clipShape(Circle())
//                            
//                        }
//                    } else {
//                        Button {
//                            removeAll(from: room)
//                        } label: {
//                            Image(systemName: "trash")
//                                .font(.system(size: 18))
//                                .foregroundColor(.brandBlack)
//                                .frame(width: 35, height: 35)
//                                .background(Color.brandWhite)
//                                .clipShape(Circle())
//                        }
//                        
//                        
//                    }
//                    
//                }.frame(height: 40)
//                    .frame(maxWidth: .infinity)
//                    .onTapGesture {
//                        if !isShowing {
//                            addFirstOne(to: room)
//                        }
//                    }
//                
//                if isShowing {
//                    
//                    HStack(spacing: 15) {
//                        
//                        Text(DimensionCallout.readableSymbol(.rentalLength))
//                            .font(.system(size: 17, weight: .medium))
//                            .foregroundStyle(Color.brandBlack)
//                            .fixedSize()
//                            .frame(minWidth: 55, alignment: .trailing)
//                        
//                        TextField("0", text: $length)
//                            .font(.system(size: 20, weight: .semibold))
//                            .foregroundStyle(Color.brandBlack)
//                            .focused($focusedDimension, equals: .first)
//                            .multilineTextAlignment(.center)
//                            .keyboardType(.numberPad)
//                            .frame(height: 30)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.brandGray)
//                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                        
//                        Text(UnitsOfMeasurement.readableSymbol(.hour))
//                            .font(.system(size: 17, weight: .medium))
//                            .foregroundStyle(Color.brandBlack)
//                            .frame(width: 40, alignment: .leading)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.all, 15)
//                    .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
//                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                    .transition(.opacity)
//                    .onAppear { length = doubleToString(from: room.toolRental) }
//                    .onChange(of: length) { _ in
//                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
//                            room.toolRental = stringToDouble(from: length)
//                            try? viewContext.save()
//                            behavioursVM.redraw()
//                        }
//                    }
//                    .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $length)
//                }
//            
//            }.padding(.horizontal, 15)
//                .padding(.vertical, 15)
//                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
//                .clipShape(RoundedRectangle(cornerRadius: room.toolRental <= 0.0 ? 20 : 30, style: .continuous))
//                .onAppear { if room.toolRental > 0 { isShowing = true } }
//        }
//    }
//    
//    func addFirstOne(to room: Room) {
//        
//        withAnimation { scrollProxy.scrollTo(ToolRental.scrollID, anchor: .top)
//            focusedDimension = .first}
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowing = true }
//        room.toolRental = 0.0
//        saveAll()
//        
//    }
//    
//    func removeAll(from room: Room) {
//        dismissKeyboard()
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowing = false }
//        room.toolRental = 0.0
//        saveAll()
//        
//    }
//    
//    func saveAll() {
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
//    }
//    
//}


struct RentalViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @State var isChoosingType = false
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
            
            let assScaffoldings = room.associatedScaffoldings
            let assCoreDrills = room.associatedCoreDrills
            let assToolRentals = room.associatedToolRentals
            
            VStack {
                
                HStack {
                    
                    Text("Rentals")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if isChoosingType {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                isChoosingType = false
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
                                isChoosingType = true
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
                    
                }.frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background { Color.brandGray }
                
                
                if isChoosingType {
                    
                    HStack {
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                createScaffolding(to: room)
                                isChoosingType = false
                            }
                        } label: {
                            RentalsTypeBubble(title: Scaffolding.title)
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                createCoreDrill(to: room)
                                isChoosingType = false
                            }
                        } label: {
                            RentalsTypeBubble(title: CoreDrill.title)
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                createToolRental(to: room)
                                isChoosingType = false
                            }
                        } label: {
                            RentalsTypeBubble(title: ToolRental.title)
                        }
                        
                    }.padding(.horizontal, 5)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandWhite)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    
                }
                
                if !assScaffoldings.isEmpty {
                    
                    ForEach(assScaffoldings) { loopedObject in
                        
                        let objectCount = assScaffoldings.count - (assScaffoldings.firstIndex(of: loopedObject) ?? 0)
                        
                        ScaffoldingsEditor(scaffolding: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.all, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                }
                
                if !assCoreDrills.isEmpty {
                    
                    ForEach(assCoreDrills) { loopedObject in
                        
                        let objectCount = assCoreDrills.count - (assCoreDrills.firstIndex(of: loopedObject) ?? 0)
                        
                        CoreDrillEditor(coreDrill: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.all, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                }
                
                if !assToolRentals.isEmpty {
                    
                    ForEach(assToolRentals) { loopedObject in
                        
                        let objectCount = assToolRentals.count - (assToolRentals.firstIndex(of: loopedObject) ?? 0)
                        
                        ToolRentalEditor(toolRental: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.all, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                    
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(
                    cornerRadius:
                        assScaffoldings.isEmpty &&
                        assCoreDrills.isEmpty &&
                        assToolRentals.isEmpty ?
                        20 : 30, style: .continuous))
                .task { withAnimation { conversionFromOldToolRentals(room: room) } }
        }
            
    }
    
    func createScaffolding(to room: Room) {
        withAnimation { scrollProxy.scrollTo(ToolRental.scrollID, anchor: .top) }
        let newEntity = Scaffolding(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.size1 = 0
        newEntity.size2 = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func createCoreDrill(to room: Room) {
        withAnimation { scrollProxy.scrollTo(ToolRental.scrollID, anchor: .top) }
        let newEntity = CoreDrill(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func createToolRental(to room: Room) {
        withAnimation { scrollProxy.scrollTo(ToolRental.scrollID, anchor: .top) }
        let newEntity = ToolRental(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.count = 0
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func conversionFromOldToolRentals(room: Room) {
        
        if room.toolRental > 0 {
            
            let newRental = ToolRental(context: viewContext)
            
            newRental.cId = UUID()
            newRental.count = room.toolRental
            newRental.fromRoom = room
            newRental.dateCreated = Date.now
            
            room.toolRental = 0
            
            saveAll()
            
        }
        
    }
    
    func saveAll() { withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() } }
    
}

fileprivate struct RentalsTypeBubble: View {
    
    var title: LocalizedStringKey
    
    var body: some View {
        
        VStack {
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
            
        }.padding(5)
            .frame(width: 100, height: 65)
            .background(Color.brandGray)
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
        
    }
    
}

fileprivate struct ScaffoldingsEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Scaffolding>
    @State var size1 = ""
    @State var size2 = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    
    init(scaffolding: Scaffolding, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = Scaffolding.fetchRequest()
        
        let cUUID = scaffolding.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Scaffolding.size1, ascending: true)]
        
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
                    
                    Text("Scaffolding no. \(objectCount)")
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
                    
                    CustomWorkValueEditingBox(title: .length, value: $size1, unit: .basicMeter)
                        .onAppear { size1 = doubleToString(from:  fetchedEntity.size1) }
                    .focused($focusedDimension, equals: .first)
                        .onChange(of: size1) { _ in
                            fetchedEntity.size1 = stringToDouble(from: size1)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    CustomWorkValueEditingBox(title: .height, value: $size2, unit: .basicMeter)
                        .onAppear { size2 = doubleToString(from:  fetchedEntity.size2) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: size2) { _ in
                            fetchedEntity.size2 = stringToDouble(from: size2)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $size1, size2: $size2)
                
            }.frame(maxWidth: .infinity)
            
        }
        
    }
    
    private func deleteObject(toDelete: Scaffolding) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = Scaffolding.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \Scaffolding.dateCreated, ascending: true)]
        
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

fileprivate struct CoreDrillEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<CoreDrill>
    @State var basicMeter = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    
    init(coreDrill: CoreDrill, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = CoreDrill.fetchRequest()
        
        let cUUID = coreDrill.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CoreDrill.count, ascending: true)]
        
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
                    
                    Text("Core drill no. \(objectCount)")
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
                    
                    CustomWorkValueEditingBox(title: .count, value: $basicMeter, unit: .hour)
                        .onAppear { basicMeter = doubleToString(from:  fetchedEntity.count) }
                        .focused($focusedDimension, equals: .first)
                        .onChange(of: basicMeter) { _ in
                            fetchedEntity.count = stringToDouble(from: basicMeter)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $basicMeter)
                
            }.frame(maxWidth: .infinity)
            
        }
        
    }
    
    private func deleteObject(toDelete: CoreDrill) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = CoreDrill.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \CoreDrill.dateCreated, ascending: true)]
        
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

fileprivate struct ToolRentalEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<ToolRental>
    @State var basicMeter = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    
    init(toolRental: ToolRental, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = ToolRental.fetchRequest()
        
        let cUUID = toolRental.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ToolRental.count, ascending: true)]
        
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
                    
                    Text("Tool no. \(objectCount)")
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
                    
                    CustomWorkValueEditingBox(title: .count, value: $basicMeter, unit: .hour)
                        .onAppear { basicMeter = doubleToString(from:  fetchedEntity.count) }
                        .focused($focusedDimension, equals: .first)
                        .onChange(of: basicMeter) { _ in
                            fetchedEntity.count = stringToDouble(from: basicMeter)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .singleWorkInputsToolbar(focusedDimension: $focusedDimension, size: $basicMeter)
                
            }.frame(maxWidth: .infinity)
            
        }
        
    }
    
    private func deleteObject(toDelete: ToolRental) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = ToolRental.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \ToolRental.dateCreated, ascending: true)]
        
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

