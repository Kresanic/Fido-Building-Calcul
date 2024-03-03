//
//  ClientEditView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/09/2023.
//

import SwiftUI

struct ClientEditView: View {
    
    var client: Client
    @Environment(\.dismiss) var dismiss
    @FetchRequest var fetchedClient: FetchedResults<Client>
    @Binding var presentationDetents: PresentationDetent
    @State var isEditingTypeOfClient = false
    @StateObject var viewModel = ClientEditViewModel()
    
    init(client: Client, presentationDetents: Binding<PresentationDetent>) {
        
        self.client = client
        
        self._presentationDetents = presentationDetents
        
        let request = Client.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.dateCreated, ascending: false)]
        
        let clientID = client.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "cId == %@", clientID as CVarArg)
        
        _fetchedClient = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let client = fetchedClient.first {
            
            ScrollView {
                VStack {
                    
                    HStack {
                        
                        Button("Zrušiť") {
                            if viewModel.hasProgressBeenMade(client: client) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    presentationDetents = .height(225)
                                }
                            } else {
                                dismiss()
                            }
                        }.frame(width: 75, alignment: .leading)
                        
                        Spacer()
                        
                        Text("Úprava klienta")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                        
                        Spacer()
                        
                        Button("Uložiť") {
                            if viewModel.createNewClient(client: client) {
                                dismiss()
                            }
                        }.frame(width: 75, alignment: .trailing)
                        
                    }.padding(.top, 25)
                        .padding(.horizontal, 25)
                    
                    if isEditingTypeOfClient {
                        EditClientTypeSelector(client: client, isEditingTypeOfClient: $isEditingTypeOfClient)
                    } else if !isEditingTypeOfClient && presentationDetents == .height(225) {
                        AttentionToDismissEditOfClient(presentationDetents: $presentationDetents)
                    } else {
                        EditingClientFields(client: client, isEditingTypeOfClient: $isEditingTypeOfClient, viewModel: viewModel)
                    }
                    
                }
                
            }.scrollDismissesKeyboard(.interactively)
                .scrollIndicators(.automatic)
                .frame(maxWidth: .infinity)
                .onChange(of: isEditingTypeOfClient) { boolean in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if boolean {
                            presentationDetents = .height(225)
                        } else {
                            presentationDetents = .large
                        }
                        
                    }
                }
                .onChange(of: presentationDetents) { detent in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if detent == .height(225) {
                            if !viewModel.hasProgressBeenMade(client: client) && !isEditingTypeOfClient{
                                dismiss()
                            }
                        }
                    }
                }
                .background{ Color.brandWhite.onTapGesture { dismissKeyboard() } }
                .onAppear { viewModel.loadClient(client) }
            
        }
    }
    
}

struct EditClientTypeSelector: View {
    
    var client: Client
    @Environment(\.managedObjectContext) var viewContext
    @Binding var isEditingTypeOfClient: Bool
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            Spacer()
            
            Text("Typ osoby?")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                            client.type = ClientType.personal.rawValue
                            try? viewContext.save()
                        }
                        withAnimation(.easeInOut) { isEditingTypeOfClient = false }
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
                            client.type = ClientType.corporation.rawValue
                            try? viewContext.save()
                        }
                        withAnimation(.easeInOut) { isEditingTypeOfClient = false }
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

struct AttentionToDismissEditOfClient: View {
    
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

struct EditingClientFields: View {
    
    var client: Client
    @Binding var isEditingTypeOfClient: Bool
    @ObservedObject var viewModel: ClientEditViewModel
    @FocusState private var focusedField: CorporationClientFields?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 4){
            
            let isClientPersonal = client.type == ClientType.personal.rawValue
            
            Image(systemName: isClientPersonal ? "person.circle.fill" : "building.columns.circle.fill")
                .font(.system(size: 130))
                .foregroundStyle(Color.brandBlack)
                .padding(.top, 20)
            
            Text(isClientPersonal ? "Súkromná osoba" : "Právnická osoba")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Button {
                withAnimation(.easeInOut) { isEditingTypeOfClient = true }
            } label: {
                Text("Upraviť typ osoby")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.brandBlack)
                    .underline()
            }.padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: Name
                VStack(alignment: .leading, spacing: 1) {
                    Text(isClientPersonal ? "Meno" : "Názov")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField(isClientPersonal ? "Meno a priezvisko" : "Názov firmy", text: $viewModel.name)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .name)
                        .onSubmit { focusedField = .email }
                        .submitLabel(.continue)
                        .textInputAutocapitalization(isClientPersonal ? .words : .never)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Email
                VStack(alignment: .leading, spacing: 1) {
                    Text("Email")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Emailová adresa", text: $viewModel.email)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        .onSubmit { focusedField = .phone }
                        .submitLabel(.continue)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.emailAddress)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Phone
                VStack(alignment: .leading, spacing: 1) {
                    Text("Telefón")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Telefonné číslo", text: $viewModel.phone)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .phone)
                        .onSubmit { focusedField = .street }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.phonePad)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Street
                VStack(alignment: .leading, spacing: 1) {
                    Text("Ulica")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Ulica a číslo domu", text: $viewModel.street)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .street)
                        .onSubmit { focusedField = .secondRowStreet }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: SecondRowStreet
                VStack(alignment: .leading, spacing: 1) {
                    Text("Druhý riadok adresy")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Doplnkové informácie", text: $viewModel.secondRowStreet)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .secondRowStreet)
                        .onSubmit { focusedField = .city }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: City
                VStack(alignment: .leading, spacing: 1) {
                    Text("Mesto")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Mesto", text: $viewModel.city)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .city)
                        .onSubmit { focusedField = .postalCode }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: PostalCode
                VStack(alignment: .leading, spacing: 1) {
                    Text("Poštové číslo")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("PSČ", text: $viewModel.postalCode)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .postalCode)
                        .onSubmit { focusedField = .country }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Country
                VStack(alignment: .leading, spacing: 1) {
                    Text("Krajina")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Krajina adresáta", text: $viewModel.country)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .country)
                        .onSubmit {
                            if client.type == ClientType.personal.rawValue {
                                if viewModel.createNewClient(client: client) {
                                    dismiss()
                                }
                            } else {
                                focusedField = .businessID
                            }
                        }
                        .submitLabel( client.type == ClientType.personal.rawValue ? .done : .continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                if client.type == ClientType.corporation.rawValue {
                    // MARK: - Business Additions
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: BusinessID
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Identifikačné číslo organizácie")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            TextField("IČO", text: $viewModel.businessID)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .focused($focusedField, equals: .businessID)
                                .onSubmit { focusedField = .taxID }
                                .submitLabel(.continue)
                                .multilineTextAlignment(.leading)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                        }
                        
                        // MARK: TaxID
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Daňové identifikačné číslo")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            TextField("DIČ", text: $viewModel.taxID)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .focused($focusedField, equals: .taxID)
                                .onSubmit { focusedField = .vatRegistrationNumber }
                                .submitLabel(.continue)
                                .multilineTextAlignment(.leading)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                        }
                        
                        // MARK: VATRegistrationNumber
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Identifikačné číslo pre daň z pridanej hodnoty")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            TextField("IČ DPH", text: $viewModel.vatRegistrationNumber)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .focused($focusedField, equals: .vatRegistrationNumber)
                                .onSubmit { focusedField = .contactPersonName }
                                .submitLabel(.continue)
                                .multilineTextAlignment(.leading)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                        }
                        
                        // MARK: ContactPersonName
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Meno kontaktnej osoby")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            TextField("Meno a priezvisko", text: $viewModel.contactPersonName)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .focused($focusedField, equals: .contactPersonName)
                                .onSubmit {
                                    if viewModel.createNewClient(client: client) {
                                        dismiss()
                                    }
                                }
                                .submitLabel(.done)
                                .submitLabel(.continue)
                                .multilineTextAlignment(.leading)
                                .keyboardType(.default)
                                .frame(maxWidth: .infinity)
                        }
                        
                        
                    }
                }
                
                Button {
                    if viewModel.createNewClient(client: client) {
                        dismiss()
                    }
                } label: {
                    Text("Uložiť klienta")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.brandWhite)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.name.isEmpty ? Color.brandGray : Color.brandBlack)
                        .clipShape(Capsule())
                }.padding(.vertical, 15)
                    .disabled(viewModel.name.isEmpty)
                
            }.padding(.horizontal, 15)
            
        }
    }
}

