//
//  ClientPreviewScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/09/2023.
//

import SwiftUI

struct ClientPreviewScreen: View {
    
    @FetchRequest var fetchedClient: FetchedResults<Client>
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @State private var isEditingClient = false
    @State var selectedDetent: PresentationDetent = .large
    @State var isCreatingAssignedProject = false
    
    init(client: Client) {
        
        let request = Client.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.dateCreated, ascending: false)]
        
        let clientID = client.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "cId == %@", clientID as CVarArg)
        
        _fetchedClient = FetchRequest(fetchRequest: request)
        
    }
    
    
    var body: some View {
        
        if let client = fetchedClient.first {
            ScrollView {
                
                VStack(alignment: .center, spacing: 20) {
                    
                    VStack(alignment: .center, spacing: 5) {
                        
                        Image(systemName: client.type == ClientType.personal.rawValue ? "person.circle.fill" : "building.columns.circle.fill")
                            .font(.system(size: 130))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(client.type == ClientType.personal.rawValue ? "Súkromná osoba" : "Právnická osoba")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        Text("Kontaktné informácie")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ClientAttributeBubble(title: "Meno", value: client.name)
                            
                            ClientAttributeBubble(title: "Email", value: client.email)
                            
                            ClientAttributeBubble(title: "Telefón", value: client.phone)
                            
                            if client.type == ClientType.corporation.rawValue {
                                ClientAttributeBubble(title: "Kontaktná osoba", value: client.contactPersonName)
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        
                    }
                    
                    if client.type == ClientType.corporation.rawValue {
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text("Firemné informácie")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                ClientAttributeBubble(title: "IČO", value: client.businessID)
                                
                                ClientAttributeBubble(title: "DIČ", value: client.taxID)
                                
                                ClientAttributeBubble(title: "IČ DPH", value: client.vatRegistrationNumber)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(15)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: 24, style: .continuous))
                            
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        Text("Doplnkové informácie")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ClientAttributeBubble(title: "Ulica", value: client.street)
                            
                            ClientAttributeBubble(title: "Druhý riadok adresy", value: client.secondRowStreet)
                            
                            ClientAttributeBubble(title: "Mesto", value: client.city)
                            
                            ClientAttributeBubble(title: "PSČ", value: client.postalCode)
                            
                            ClientAttributeBubble(title: "Krajina", value: client.country)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        
                    }
                    
                    
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            HStack {
                                
                                Text("Klientové projekty")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                if !client.associatedProjects.isEmpty {
                                    Button { isCreatingAssignedProject = true } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color.brandBlack)
                                    }
                                    
                                }
                                
                            }
                            
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    if !client.associatedProjects.isEmpty {
                                    ForEach(client.associatedProjects) { assProject in
                                        
                                        Button {
                                            behaviourVM.switchToProjectsPage(with: assProject)
                                        } label: {
                                            ClientsProjectBubble(project: assProject)
                                        }
                                        
                                    }
                                        
                                    } else {
                                        
                                        Button { isCreatingAssignedProject = true } label: {
                                            HStack {
                                                Text("Vytvoriť projekt pre klienta")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundStyle(Color.brandBlack)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "plus")
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(Color.brandBlack)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 20)
                                            .background(Color.brandWhite)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        }
                                        
                                    }
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(15)
                                    .background(Color.brandGray)
                                    .clipShape(.rect(cornerRadius: 24, style: .continuous))
                                
                            
                            
                        
                    }
                    
                    Button {
                        isEditingClient = true
                    } label: {
                        EditClientButton()
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 80)
                
            }.sheet(isPresented: $isEditingClient) {
                if #available(iOS 16.4, *) {
                    ClientEditView(client: client, presentationDetents: $selectedDetent)
                        .presentationDetents([.height(225), .large], selection: $selectedDetent)
                        .presentationCornerRadius(25)
                        .interactiveDismissDisabled(true)
                        .presentationDragIndicator(.hidden)
                        .onDisappear { selectedDetent = .large }
                } else {
                    ClientEditView(client: client, presentationDetents: $selectedDetent)
                        .presentationDetents([.height(225), .large], selection: $selectedDetent)
                        .interactiveDismissDisabled(true)
                        .presentationDragIndicator(.hidden)
                        .onDisappear { selectedDetent = .large }
                }
            }
            .sheet(isPresented: $isCreatingAssignedProject) {
                if #available(iOS 16.4, *) {
                    NewProjectSheet(toClient: client)
                        .presentationDetents([.height(350)])
                        .presentationCornerRadius(25)
                } else {
                    NewProjectSheet(toClient: client)
                        .presentationDetents([.height(350)])
                }
            }
            
        }
        
    }
    
}

struct ClientAttributeBubble: View {
    
    var title: String
    var value: String?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.brandBlack)
            
            Text(stringToShow(value: value))
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
        }
        
    }
    
    func stringToShow(value: String?) -> String {
        
        var stringToShow = "-"
        
        if let value {
            if !value.isEmpty {
                stringToShow = value
            }
        }
        
        return stringToShow
        
    }
    
}

struct ClientsProjectBubble: View {
    
    var project: Project
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @EnvironmentObject var priceCalc: PricingCalculations
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    
    init(project: Project) {
        
        self.project = project
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            VStack(alignment: .leading) {
                
                Text(project.unwrappedName)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.leading)
                
                Text(project.numberOfRooms == 1 ? "\(project.numberOfRooms) miestnosť" : "\(project.numberOfRooms) miestnost\(project.numberOfRooms < 0 ? "i" : "i")")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            
            Spacer(minLength: 20)
            
            if let priceList = fetchedPriceList.last {
                
                let priceCalc = priceCalc.projectPriceBillCalculations(project: project, priceList: priceList)
                
                if priceCalc.priceWithoutVat > 0 {
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        
                        Text("bez DPH")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(priceCalc.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.brandBlack)
                        
                    }.padding(.trailing, behavioursVM.toRedraw ? 0.5 : 0)
                    
                }
                
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(Color.brandWhite)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
        
    }
    
    
}

struct EditClientButton: View {
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Spacer()
            
            Text("Upraviť klienta")
                .font(.system(size: 20, weight: .medium))
            
            Image(systemName: "scissors")
                .font(.system(size: 18, weight: .regular))
            
            Spacer()
            
        }
        .foregroundStyle(Color.brandWhite)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.brandBlack)
        .clipShape(Capsule())
        
        
    }
    
}


struct NewProjectSheet: View {
    
    var toClient: Client?
    var toCategory: PropertyCategories?
    @State var category: PropertyCategories? = nil
    @State var nameOfProject = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button("Zrušiť") {
                    dismiss()
                }.frame(width: 75, alignment: .leading)
                
                Spacer()
                
                Text("Nový projekt")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                Spacer()
                
                Button("Vytvoriť") {
                    
                }.frame(width: 75, alignment: .trailing)
                
                
            }.padding(.top, 25)
                .padding(.horizontal, 10)
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("Názov projektu")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("Názov projektu", text: $nameOfProject)
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .submitLabel(.done)
                    .multilineTextAlignment(.center)
                    .keyboardType(.default)
                    .frame(maxWidth: .infinity)
            }.padding(.top, 10)
            
            
            Spacer()
            
            if toCategory == nil {
                VStack(spacing: 5) {
                    
                    Text("Typ projektu")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                    
                    ProjectCategorySelector(category: $category)
                    
                }
            }
            
            Spacer()
            
            Button {
                createNewProject()
            } label: {
                
                Text("Vytvoriť projekt")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.brandBlack.opacity(0.8))
                    .clipShape(.rect(cornerRadius: 25, style: .continuous))
                
            }.padding(.bottom, 10)
            
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
            .background(Color.brandWhite)
        .onAppear { if let updateCategory = toCategory { category = updateCategory } }
         
    }
    
    private func createNewProject() {
        
        guard let category = category else { return }
        guard !nameOfProject.isEmpty else { return }
        
        let newProject = Project(context: viewContext)
        
        newProject.cId = UUID()
        newProject.category = category.rawValue
        newProject.name = nameOfProject
        newProject.dateCreated = Date.now
        newProject.isArchived = false
        
        #warning("Add Price List!!!NEED TO CREATE RENAMED ONE WITH DEFAULT PRICES!!!")
        
        try? viewContext.save()
        dismiss()
        behaviourVM.switchToProjectsPage(with: newProject)
        
    }
    
}


struct ProjectCategorySelector: View {
    
    @Binding var category: PropertyCategories?
    
    var body: some View {
        
        HStack(spacing: 10) {
            
            ProjectCategorySelectorBubble(title: "Byt", category: .flats, changeCategory: $category)
            
            ProjectCategorySelectorBubble(title: "Dom", category: .houses, changeCategory: $category)
            
            ProjectCategorySelectorBubble(title: "Firma", category: .firms, changeCategory: $category)
            
            ProjectCategorySelectorBubble(title: "Chata", category: .cottages, changeCategory: $category)
            
        }
        
    }
    
}


struct ProjectCategorySelectorBubble: View {
    
    var title: String
    var category: PropertyCategories
    @Binding var changeCategory: PropertyCategories?
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { changeCategory = category }
        } label: {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(changeCategory == category ?  Color.brandWhite : Color.brandBlack)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(changeCategory == category ?  Color.brandBlack : Color.brandGray)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
        }
    }
    
}
