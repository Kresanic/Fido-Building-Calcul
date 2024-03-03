//
//  UIParts.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct ValueEditingBox: View {
    
    var title: String
    @Binding var value: String
    var unit: UnitsOfMeasurment
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("0", text: $value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(width: 65, height: 30)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(UnitsOfMeasurment.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }
        
    }
    
}

struct CustomWorkPriceEditingBox: View {
    
    var title: String
    @Binding var price: Double
    var unit: CustomWorkUnits
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("€0.00", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 30)
                .frame(idealWidth: 65, maxWidth: 90)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            
            Text("/\(unit.rawValue)")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }
        
    }
    
}

struct CustomWorkValueEditingBox: View {
    
    var title: String
    @Binding var value: String
    var unit: CustomWorkUnits
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("0", text: $value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 30)
                .frame(idealWidth: 65, maxWidth: 90)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(unit.rawValue)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }
        
    }
    
}

struct ValueEditingBoxSmall: View {
    
    var title: String
    @Binding var value: String
    var unit: UnitsOfMeasurment
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("0", text: $value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(width: 40, height: 25)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            
            Text(UnitsOfMeasurment.readableSymbol(unit))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .minimumScaleFactor(0.7)
            
        }
        
    }
    
}


struct DoorEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Door>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    var objectCount: Int
    
    init(door: Door, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = Door.fetchRequest()
        
        let cUUID = door.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Door.dateCreated, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(spacing: 0) {
                
                    Text("Dvere č.\(objectCount)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteDoors(toDelete: fetchedEntity)
                        behavioursVM.forceRedrawOfRoomCalculationBill()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                    }
                    
                }
                
                VStack {
                    
                    ValueEditingBoxSmall(title: "Šírka", value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    ValueEditingBoxSmall(title: "Výška", value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                }
                
                
            }.padding(.horizontal, 5)
                .transition(.scale)
            
        }
        
    }
    
    func deleteDoors(toDelete: Door) {

        let requestObjectsToDelete = Door.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \Door.size1, ascending: true)]

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
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct WindowEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Window>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    var objectCount: Int
    
    init(window: Window, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = Window.fetchRequest()
        
        let cUUID = window.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Window.dateCreated, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(spacing: 0) {
                
                    Text("Okno č.\(objectCount)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    Button {
                        deleteWindows(toDelete: fetchedEntity)
                        behavioursVM.forceRedrawOfRoomCalculationBill()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                    }
                    
                }
                
                VStack {
                    
                    ValueEditingBoxSmall(title: "Šírka", value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                    ValueEditingBoxSmall(title: "Výška", value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.forceRedrawOfRoomCalculationBill()
                        }
                    
                }
                
                
                
                
            }.padding(.horizontal, 5)
                .transition(.scale)
            
        }
        
    }
    
    func deleteWindows(toDelete: Window) {

        let requestObjectsToDelete = Window.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \Window.size1, ascending: true)]

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
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct ScreenTitle: View {
    
    let title: String
    
    var body: some View {
    
        HStack {
            Text(title)
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(Color.brandBlack)
                .padding(.vertical, 15)
            
            Spacer()
            
        }
        
    }
    
}

struct ScreenTitleWithSwitch: View {
    
    let title: String
    @Binding var toSwitch: Bool
    let sfSymbol: String
    var showSwitch: Bool
    
    var body: some View {
    
        HStack {
            
            Text(title)
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(Color.brandBlack)
                .padding(.vertical, 15)
            
            Spacer()
            
            if showSwitch {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) { toSwitch = true }
                } label: {
                    Image(systemName: sfSymbol)
                        .font(.system(size: 30))
                        .foregroundColor(.brandBlack)
                }
            }
            
        }
        
    }
    
}

struct ClientBubbleView: View {
    
    var isDeleting: Bool
    var isGrayBackground: Bool = true
    @FetchRequest var fetchedClient: FetchedResults<Client>
    
    init(client: Client, isDeleting: Bool, isGrayBackground: Bool = true) {
        
        self.isDeleting = isDeleting
        
        self.isGrayBackground = isGrayBackground
        
        let request = Client.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.dateCreated, ascending: false)]
        
        let clientcId = client.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "cId == %@", clientcId as CVarArg)
        
        _fetchedClient = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        
        if let client = fetchedClient.first {
            HStack {
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    Text(client.unwrappedName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    if client.street != "" && client.city != "" {
                        Text("\(client.street == nil ? "" : "\(client.unwrappedStreet)")\(client.street != nil && client.city != nil ? "," : "") \(client.unwrappedCity)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.8))
                    }
                    
                }
                
                Spacer()
                
                if !isDeleting {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.brandBlack)
                }
                
            }.padding(.vertical, client.street != "" && client.city != "" ? 15 : 20)
                .padding(.horizontal, 15)
                .background(isGrayBackground ? Color.brandGray : Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
}

struct InProjectClientBubbleView: View {
    
    var client: Client
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(client.unwrappedName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                if client.street != "" && client.city != "" {
                    Text("\(client.street == nil ? "" : "\(client.unwrappedStreet)")\(client.street != nil && client.city != nil ? "," : "") \(client.unwrappedCity)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                }
                
            }
            
            Spacer()
            
        }.padding(.vertical, client.street != "" && client.city != "" ? 15 : 20)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
}

struct NoClientBubbleView: View {
    
    @Binding var isCreatingNewClient: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Spacer()
            
            Image(systemName: "person.text.rectangle.fill")
                .font(.system(size: 80, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
            Text("Pridajte klienta")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
            
            Text("Pridajte svojho prvého klienta a následne priradťe projekt k nemu.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 35)
            
            Button {
                isCreatingNewClient = true
            } label: {
                Text("Vytvoriť")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding(.top, 25)
            }
            
            Spacer()
        
        }.padding(.vertical, 25)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .padding(.horizontal, 15)
        
    }
    
}

struct ClientTypeSelector: View {
    
    @Binding var activeClientType: ClientType?
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            
            Text("Typ osoby?")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                            activeClientType = .personal
                        }
                    } label: {
                        Text("Súkromná")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: 140, height: 50)
                            .background(Color.brandWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                            activeClientType = .corporation
                        }
                    } label: {
                        Text("Právnická")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: 140, height: 50)
                            .background(Color.brandWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
            }

            Spacer()
            
        }.frame(maxWidth: .infinity)
            .background(Color.brandGray)
            .clipShape(.rect(cornerRadius: 24, style: .continuous))
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 10)
        
    }
    
}

struct AttentionToDismissCreationOfClient: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var presentationDetents: PresentationDetent
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            
            Text("Chcete zahodiť zmeny?")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            GeometryReader { mainGeo in
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                            dismiss()
                        }
                    } label: {
                        Text("Áno")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: mainGeo.size.width * 0.4, height: 50)
                            .background(Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                            presentationDetents = .large
                        }
                    } label: {
                        Text("Nie")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandWhite)
                            .frame(width: mainGeo.size.width * 0.4, height: 50)
                            .background(Color.brandBlack)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
                }
            }

            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 10)
        
    }
    
}

