//
//  PavingCeramicViews.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct PavingCeramicViews: View {
    
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
                        
                        Text(PavingCeramic.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(PavingCeramic.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        createNewEntity(to: room)
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
                .onTapGesture {  createNewEntity(to: room) }
                
                if !room.associatedPavingCeramics.isEmpty {
                    ForEach(room.associatedPavingCeramics) { loopedObject in
                        
                        let objectCount = room.associatedPavingCeramics.count - (room.associatedPavingCeramics.firstIndex(of: loopedObject) ?? 0)
                        
                        PavingCeramicEditor(pavingCeramic: loopedObject, objectCount: objectCount)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background { Color.brandWhite.onTapGesture { dismissKeyboard() } }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .transition(.opacity)
                }
                
            }.padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background { Color.brandGray.onTapGesture { dismissKeyboard() } }
                .clipShape(RoundedRectangle(cornerRadius: room.associatedPavingCeramics.isEmpty ? 20 : 30, style: .continuous))
        }
    }
    
    func createNewEntity(to room: Room) {
        withAnimation { scrollProxy.scrollTo(PavingCeramic.scrollID, anchor: .top) }
        let newEntity = PavingCeramic(context: viewContext)
        
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

fileprivate struct PavingCeramicEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<PavingCeramic>
    @State var width = ""
    @State var length = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    private var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    enum FocusedPlinth { case cutting, bonding }
    @FocusState var whatPlinthIsFocused: FocusedPlinth?
    @State var plinthCutting: String = ""
    @State var plinthBonding: String = ""
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    init(pavingCeramic: PavingCeramic, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = PavingCeramic.fetchRequest()
        
        let cUUID = pavingCeramic.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PavingCeramic.size1, ascending: true)]
        
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
                    
                    Text("Laying no. \(objectCount)")
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
            
                VStack(alignment: .leading, spacing: 5) {
                    
                    ComplementaryWorksBubble(work: LargeFormatPavingAndTiling.self, isSwitchedOn: fetchedEntity.largeFormat, subTitle: true) {
                        fetchedEntity.largeFormat.toggle()
                        saveAll()
                    }
                    
                    HStack(spacing: 3) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text(PlinthCutting.title)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                            
                            Text(PlinthCutting.subTitle)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.brandBlack.opacity(0.75))
                                .lineLimit(1)
                            
                        }.fixedSize()
                        
                        Spacer()
                        
                        HStack(alignment: .lastTextBaseline, spacing: 5) {
                            
                            TextField("0", text: $plinthCutting)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .frame(maxWidth: 100, alignment: .trailing)
                                .onAppear { plinthCutting = doubleToString(from: fetchedEntity.plinthCutting) }
                                .focused($whatPlinthIsFocused, equals: .cutting)
                                .onChange(of: plinthCutting) { _ in
                                    fetchedEntity.plinthCutting = stringToDouble(from: plinthCutting)
                                    try? viewContext.save()
                                    behavioursVM.redraw()
                                }
                            
                            Text(UnitsOfMeasurement.readableSymbol(PlinthCutting.unit))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                                .frame(alignment: .leading)
                        }
                        
                    }.padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.brandGray)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    
                    HStack(spacing: 3) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text(PlinthBonding.title)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                            
                            Text(PlinthBonding.subTitle)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.brandBlack.opacity(0.75))
                                .lineLimit(1)
                            
                        }.fixedSize()
                        
                        Spacer()
                        
                        HStack(alignment: .lastTextBaseline, spacing: 5) {
                            
                            TextField("0", text: $plinthBonding)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .frame(maxWidth: 100, alignment: .trailing)
                                .onAppear { plinthBonding = doubleToString(from: fetchedEntity.plinthBonding) }
                                .focused($whatPlinthIsFocused, equals: .bonding)
                                .onChange(of: plinthBonding) { _ in
                                    fetchedEntity.plinthBonding = stringToDouble(from: plinthBonding)
                                    try? viewContext.save()
                                    behavioursVM.redraw()
                                }
                            
                            Text(UnitsOfMeasurement.readableSymbol(PlinthBonding.unit))
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                                .frame(alignment: .leading)
                        }
                        
                    }.padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.brandGray)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                        
                    
                }.padding(.horizontal, 10)
                .padding(.bottom, 10)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        keyboardToolbarContent()
                    }
                }
                
            }.padding(.horizontal, 10)
            
        }
        
    }
    
    private func deleteObject(toDelete: PavingCeramic) {
        
        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = PavingCeramic.fetchRequest()
        
        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \PavingCeramic.size2, ascending: true)]
        
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            try? viewContext.save()
            behavioursVM.redraw()
        }
    }
    
    @ViewBuilder
    private func keyboardToolbarContent() -> some View {
        if whatPlinthIsFocused == .bonding {
            HStack(spacing: 0) {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton(isBonding: true).frame(width: 75)
            }
        } else if whatPlinthIsFocused == .cutting {
            HStack(spacing: 0) {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton(isBonding: false).frame(width: 75)
            }
        }
    }

    private func doneButton(isBonding: Bool) -> some View {
        Button {
            withAnimation {
                if isBonding {
                    plinthBonding = calculate(on: plinthBonding)
                } else  {
                    plinthCutting = calculate(on: plinthCutting)
                }
                whatPlinthIsFocused = nil
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
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            Button("-") {
                addSymbol("-")
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("+") {
                addSymbol("+")
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("*") {
                addSymbol("*")
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            
            Button("=") {
                if whatPlinthIsFocused == .bonding {
                    plinthBonding = calculate(on: plinthBonding)
                } else if whatPlinthIsFocused == .cutting {
                    plinthCutting = calculate(on: plinthCutting)
                }
                impactHeavy.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func addSymbol(_ s: String) {
        switch whatPlinthIsFocused {
        case .cutting:
            if let last = plinthCutting.last, !["+","*","-"].contains(last) {
                plinthCutting = plinthCutting + s
            } else {
                impactHeavy.impactOccurred()
            }
        case .bonding:
            if let last = plinthBonding.last, !["+","*","-"].contains(last) {
                plinthBonding = plinthBonding + s
            } else {
                impactHeavy.impactOccurred()
            }
        case nil:
            break
        }
        impactMed.impactOccurred()
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard expressionString.numberOfOccurrencesOf(string: ",") < 2 else { return expressionString.beforeCommaOrDot }
        
        guard expressionString.numberOfOccurrencesOf(string: ".") < 2 else { return expressionString.beforeCommaOrDot }
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
                
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        let roundedResult = Double(round(100 * result) / 100)
        
        return dbToStr(from: roundedResult)
        
    }
    
    private func dbToStr(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
}

