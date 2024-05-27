//
//  CustomWorkViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/08/2023.
//

import SwiftUI

enum CustomWorkUnits: String, CaseIterable {
    
    case basicMeter, squareMeter, cubicMeter, piece, package, hour, kilometer, day
    
    static func readableSymbol(_ self: Self) -> LocalizedStringKey {
        switch self {
        case .basicMeter:
            return "bm"
        case .squareMeter:
            return "m\u{00B2}"
        case .cubicMeter:
            return "m\u{00B3}"
        case .piece:
            return "pc"
        case .package:
            return "pkg"
        case .hour:
            return "h"
        case .kilometer:
            return "km"
        case .day:
            return "day"
        }
        
    }
    
    static func parse(_ s: String?) -> UnitsOfMeasurement {
        switch s {
        case "basicMeter":
            return .basicMeter
        case "squareMeter":
            return .squareMeter
        case "cubicMeter":
            return .cubicMeter
        case "piece":
            return .piece
        case "package":
            return .package
        case "hour":
            return .hour
        case "kilometer":
            return .kilometer
        case "day":
            return .day
        default:
            return .basicMeter
        }
    }
}

enum CustomMaterialUnits: String, CaseIterable {
    
    case basicMeter, squareMeter, cubicMeter, piece, package, kilogram, ton, kilometer
    
    static func readableSymbol(_ self: Self) -> LocalizedStringKey {
        switch self {
        case .basicMeter:
            return "bm"
        case .squareMeter:
            return "m\u{00B2}"
        case .cubicMeter:
            return "m\u{00B3}"
        case .piece:
            return "pc"
        case .package:
            return "pkg"
        case .kilogram:
            return "kg"
        case .kilometer:
            return "km"
        case .ton:
            return "t"
        }
        
    }
    
    static func parse(_ s: String?) -> CustomMaterialUnits {
        switch s {
        case "basicMeter":
            return .basicMeter
        case "squareMeter":
            return .squareMeter
        case "cubicMeter":
            return .cubicMeter
        case "piece":
            return .piece
        case "package":
            return .package
        case "kilogram":
            return .kilogram
        case "kilometer":
            return .kilometer
        case "ton":
            return .ton
        default:
            return .basicMeter
        }
    }
}

struct CustomWorksAndMaterialsViews: View {
    
    @FetchRequest var fetchedRoom: FetchedResults<Room>
    @State var isChoosingWhichCustomType = false
    @Environment(\.managedObjectContext) var viewContext
    @Namespace private var customWAMAnimation
    @Namespace private var plusToRectangleBuuble
    @State var isCreatingNewCustomWork = false
    @State var isCreatingNewCustomMaterial = false
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
                    
                    Text("Custom work and material")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if !isChoosingWhichCustomType && !isCreatingNewCustomWork && !isCreatingNewCustomMaterial {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                isChoosingWhichCustomType = true
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
                    if !isChoosingWhichCustomType && !isCreatingNewCustomWork && !isCreatingNewCustomMaterial {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            isChoosingWhichCustomType = true
                        }
                    }
                }
                
                if isChoosingWhichCustomType {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                isChoosingWhichCustomType = false
                                isCreatingNewCustomWork = true
                            }
                        } label: {
                            HStack(spacing: 3) {
                                
                                Image(systemName: "hammer.fill")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Text("Work")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                    .fixedSize()
                                
                            }.padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: 50, style: .continuous))
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                isChoosingWhichCustomType = false
                                isCreatingNewCustomMaterial = true
                            }
                        } label: {
                            HStack(spacing: 3) {
                                
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Text("Material")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                    .fixedSize()
                                
                            }.padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: 50, style: .continuous))
                        }
                        
                        Spacer()
                        
                    }.padding(25)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .transition(.asymmetric(insertion: .scale(scale: 0.0, anchor: .topTrailing), removal: .opacity.combined(with: .scale)))
                    
                    
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
                            
                            Text("Units of measurement")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
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
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                            createNewCustomWork(to: room, of: customUnit)
                                            isCreatingNewCustomWork = false
                                        }
                                    }
                                
                            }
                        }.padding(.horizontal, 15)
                            .padding(.bottom, 5)
                        
                    }.padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
                
                if isCreatingNewCustomMaterial {
                    
                    VStack {
                        
                        HStack(spacing: 0) {
                            
                            Image(systemName: "ruler")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.brandBlack)
                                .rotationEffect(.degrees(90))
                                .padding(.trailing, -3)
                                .padding(.leading, 10)
                            
                            Text("Units of measurement")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                    isCreatingNewCustomMaterial = false
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
                            ForEach(CustomMaterialUnits.allCases, id: \.self) { customUnit in
                                
                                CustomMaterialsUnitsButton(customUnit: customUnit)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                            createNewCustomMaterial(to: room, of: customUnit)
                                            isCreatingNewCustomMaterial = false
                                        }
                                    }
                                
                            }
                        }.padding(.horizontal, 15)
                            .padding(.bottom, 5)
                        
                    }.padding(.vertical, 10)
                        .background { Color.brandMaterialGray.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
                
                VStack(spacing: 10) {
                    
                    if !room.associatedCustomWorks.isEmpty {
                        
                        VStack(spacing: 2) {
                            
                            HStack(alignment: .center, spacing: 2) {
                                
                                Image(systemName: "hammer.fill")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color.brandBlack)
                                
                                Text("Work")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color.brandBlack)
                                
                                Spacer()
                                
                            }
                            
                            VStack {
                                ForEach(room.associatedCustomWorks) { loopedObject in
                                    CustomWorksEditor(customWork: loopedObject)
                                }.frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .transition(.opacity)
                            }
                        }
                        
                    }
                    
                    if !room.associatedCustomMaterials.isEmpty {
                        
                        VStack(spacing: 2) {
                            
                            HStack(alignment: .center, spacing: 2) {
                                
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color.brandBlack)
                                
                                Text("Material")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color.brandBlack)
                                
                                Spacer()
                                
                            }
                            
                            VStack {
                                ForEach(room.associatedCustomMaterials) { loopedObject in
                                    CustomMaterialsEditor(customMaterial: loopedObject)
                                }.frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background { Color.brandMaterialGray.onTapGesture { dismissKeyboard() } } // TODO: CHANGE BACK COLOR
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .transition(.opacity)
                            }
                            
                        }
                        
                    }
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedCustomWorks.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewCustomWork(to room: Room, of unit: CustomWorkUnits) {
        withAnimation { scrollProxy.scrollTo(CustomWork.scrollID, anchor: .top) }
        let newEntity = CustomWork(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.pricePerUnit = 0
        newEntity.numberOfUnits = 0
        newEntity.title = ""
        newEntity.unit = unit.rawValue
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    func createNewCustomMaterial(to room: Room, of unit: CustomMaterialUnits) {
        withAnimation { scrollProxy.scrollTo(CustomWork.scrollID, anchor: .top) }
        let newEntity = CustomMaterial(context: viewContext)
        
        newEntity.cId = UUID()
        newEntity.pricePerUnit = 0
        newEntity.numberOfUnits = 0
        newEntity.title = ""
        newEntity.unit = unit.rawValue
        newEntity.fromRoom = room
        newEntity.dateCreated = Date.now
        saveAll()
        
    }
    
    private func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct CustomWorksUnitsButton: View {
    
    var customUnit: CustomWorkUnits
    
    var body: some View {
        
        Text(CustomWorkUnits.readableSymbol(customUnit))
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

struct CustomMaterialsUnitsButton: View {
    
    var customUnit: CustomMaterialUnits
    
    var body: some View {
        
        Text(CustomMaterialUnits.readableSymbol(customUnit))
            .font(.system(size: 20))
            .foregroundStyle(Color.brandBlack)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 2)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
    }
}


fileprivate struct CustomWorksEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<CustomWork>
    @State var pricePerUnit = ""
    @State var numberOfUnits = ""
    @State var customWorkName = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: Int?
    
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
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    
                    Image(systemName: "ruler")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.brandBlack)
                        .rotationEffect(.degrees(90))
                        .padding(.trailing, -3)
                    
                    TextField("Work name", text: $customWorkName, axis: .vertical)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .lineLimit(1...4)
                    .submitLabel(.next)
                    .onSubmit { focusedDimension = 1 }
                    .focused($focusedDimension, equals: 0)
                    .toolbar {
                        if focusedDimension == 0 {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    Button {
                                        withAnimation {
                                            focusedDimension = nil
                                        }
                                    } label: {
                                        Text("Done")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.brandWhite)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background { Color.brandBlack}
                                            .clipShape(.capsule)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        withAnimation {
                                            focusedDimension = 1
                                        }
                                    } label: {
                                        Text("Next")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.brandWhite)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background { Color.brandBlack}
                                            .clipShape(.capsule)
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: customWorkName) { _ in
                        fetchedEntity.title = customWorkName
                        try? viewContext.save()
                    }
                    .onChange(of: focusedDimension) { value in
                        behavioursVM.redraw()
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
                    
                    CustomWorkValueEditingBox(title: .count, value: $numberOfUnits, unit: CustomWorkUnits(rawValue: fetchedEntity.unit ?? "bm") ?? CustomWorkUnits.basicMeter)
                        .onAppear { numberOfUnits = doubleToString(from: fetchedEntity.numberOfUnits) }
                        .focused($focusedDimension, equals: 1)
                        .onChange(of: numberOfUnits) { _ in
                            fetchedEntity.numberOfUnits = stringToDouble(from: numberOfUnits)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    CustomWorkPriceEditingBox(title: .price, price: $pricePerUnit, unit: CustomWorkUnits(rawValue: fetchedEntity.unit ?? "bm") ?? CustomWorkUnits.basicMeter)
                        .onAppear { pricePerUnit = doubleToString(from: fetchedEntity.pricePerUnit) }
                        .focused($focusedDimension, equals: 2)
                        .onChange(of: pricePerUnit) { _ in
                            fetchedEntity.pricePerUnit = stringToDouble(from: pricePerUnit)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.onAppear { customWorkName = fetchedEntity.title ?? "" }
                    .task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = 0 } } }
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            if focusedDimension != nil {
                                if focusedDimension == 1 {
                                    keyboardToolbarContent(for: 1)
                                } else if focusedDimension == 2 {
                                    keyboardToolbarContent(for: 2)
                                }
                            }
                        }
                        
                    }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: CustomWork) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
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
    
    
    private func saveAll() { withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() } }
    
    // TOOLBAR FOR CUSTOM WORK
    
    @ViewBuilder
    private func keyboardToolbarContent(for dimension: Int?) -> some View {
        HStack(spacing: 0) {
            if dimension == 1 {
                doneButton().frame(width: 75)
                mathSymbols()
                nextButton().frame(width: 75)
            } else if dimension == 2 {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton().frame(width: 75)
            }
        }
    }
    
    private func doneButton() -> some View {
        Button {
            withAnimation {
                focusedDimension = nil
                pricePerUnit = calculate(on: pricePerUnit)
                numberOfUnits = calculate(on: numberOfUnits)
            }
        } label: {
            Text("Done")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }
    
    private func nextButton() -> some View {
        Button {
            withAnimation {
                focusedDimension = 2
                numberOfUnits = calculate(on: numberOfUnits)
            }
        } label: {
            Text("Next")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
        
    }
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            
            Button("-") {
                if focusedDimension == 2 {
                    pricePerUnit = pricePerUnit + "-"
                } else if focusedDimension == 1 {
                    numberOfUnits = numberOfUnits + "-"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
            
            Button("+") {
                if focusedDimension == 2 {
                    pricePerUnit = pricePerUnit + "+"
                } else if focusedDimension == 1 {
                    numberOfUnits = numberOfUnits + "+"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
            
            Button("*") {
                if focusedDimension == 2 {
                    pricePerUnit = pricePerUnit + "*"
                } else if focusedDimension == 1 {
                    numberOfUnits = numberOfUnits + "*"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            
            Button("=") {
                if focusedDimension == 2 {
                    pricePerUnit = calculate(on: pricePerUnit)
                } else if focusedDimension == 1 {
                    numberOfUnits = calculate(on: numberOfUnits)
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
        
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        return dbToStr(from: result)
        
    }
    
    private func dbToStr(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
}


fileprivate struct CustomMaterialsEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<CustomMaterial>
    @State var pricePerUnit = ""
    @State var numberOfUnits = ""
    @State var customMaterialName = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: Int?
    
    init(customMaterial: CustomMaterial) {
        
        let entityRequest = CustomMaterial.fetchRequest()
        
        let cUUID = customMaterial.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CustomMaterial.dateCreated, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    
                    Image(systemName: "ruler")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.brandBlack)
                        .rotationEffect(.degrees(90))
                        .padding(.trailing, -3)
                    
                    TextField("Material name", text: $customMaterialName, axis: .vertical)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .lineLimit(1...4)
                    .submitLabel(.next)
                    .onSubmit { focusedDimension = 1 }
                    .focused($focusedDimension, equals: 0)
                    .toolbar {
                        if focusedDimension == 0 {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    Button {
                                        withAnimation {
                                            focusedDimension = nil
                                        }
                                    } label: {
                                        Text("Done")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.brandWhite)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background { Color.brandBlack}
                                            .clipShape(.capsule)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        withAnimation {
                                            focusedDimension = 1
                                        }
                                    } label: {
                                        Text("Next")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(Color.brandWhite)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background { Color.brandBlack}
                                            .clipShape(.capsule)
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: customMaterialName) { _ in
                        fetchedEntity.title = customMaterialName
                        try? viewContext.save()
                    }
                    .onChange(of: focusedDimension) { value in
                        behavioursVM.redraw()
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
                    
                    CustomMaterialValueEditingBox(title: .count, value: $numberOfUnits, unit: CustomMaterialUnits.parse(fetchedEntity.unit), isMaterial: true)
                        .onAppear { numberOfUnits = doubleToString(from: fetchedEntity.numberOfUnits) }
                        .focused($focusedDimension, equals: 1)
                        .onChange(of: numberOfUnits) { _ in
                            fetchedEntity.numberOfUnits = stringToDouble(from: numberOfUnits)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    CustomMaterialPriceEditingBox(title: .price, price: $pricePerUnit, unit: CustomMaterialUnits.parse(fetchedEntity.unit), isMaterial: true)
                        .onAppear { pricePerUnit = doubleToString(from: fetchedEntity.pricePerUnit) }
                        .focused($focusedDimension, equals: 2)
                        .onChange(of: pricePerUnit) { _ in
                            fetchedEntity.pricePerUnit = stringToDouble(from: pricePerUnit)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.onAppear { customMaterialName = fetchedEntity.title ?? "" }
                    .task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = 0 } } }
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            if focusedDimension != nil {
                                if focusedDimension == 1 {
                                    keyboardToolbarContent(for: 1)
                                } else if focusedDimension == 2 {
                                    keyboardToolbarContent(for: 2)
                                }
                            }
                        }
                        
                    }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: CustomMaterial) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = CustomMaterial.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \CustomMaterial.dateCreated, ascending: true)]
        
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
    
    // TOOLBAR FOR CUSTOM MATERIAL
    
    @ViewBuilder
    private func keyboardToolbarContent(for dimension: Int?) -> some View {
        HStack(spacing: 0) {
            if dimension == 1 {
                doneButton().frame(width: 75)
                mathSymbols()
                nextButton().frame(width: 75)
            } else if dimension == 2 {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton().frame(width: 75)
            }
        }
    }
    
    private func doneButton() -> some View {
        Button {
            withAnimation {
                focusedDimension = nil
                pricePerUnit = calculate(on: pricePerUnit)
                numberOfUnits = calculate(on: numberOfUnits)
            }
        } label: {
            Text("Done")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }
    
    private func nextButton() -> some View {
        Button {
            withAnimation {
                focusedDimension = 2
                numberOfUnits = calculate(on: numberOfUnits)
            }
        } label: {
            Text("Next")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
        
    }
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            
            Button("-") {
                if focusedDimension == 2 {
                    pricePerUnit = pricePerUnit + "-"
                } else if focusedDimension == 1 {
                    numberOfUnits = numberOfUnits + "-"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
            
            Button("+") {
                if focusedDimension == 2 {
                    pricePerUnit = pricePerUnit + "+"
                } else if focusedDimension == 1 {
                    numberOfUnits = numberOfUnits + "+"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
            
            Button("*") {
                if focusedDimension == 2 {
                    pricePerUnit = pricePerUnit + "*"
                } else if focusedDimension == 1 {
                    numberOfUnits = numberOfUnits + "*"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            
            Button("=") {
                if focusedDimension == 2 {
                    pricePerUnit = calculate(on: pricePerUnit)
                } else if focusedDimension == 1 {
                    numberOfUnits = calculate(on: numberOfUnits)
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
        
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        return dbToStr(from: result)
        
    }
    
    private func dbToStr(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
}

