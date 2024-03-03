//
//  CorporationClientCreationView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/08/2023.
//

import SwiftUI

struct CorporationClientCreationView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    var isCzechoSlovak: Bool { (locale.identifier.hasPrefix("sk") || locale.identifier.hasPrefix("cz")) ? true : false }
    var isSlovak: Bool { locale.identifier.hasPrefix("sk") }
    @ObservedObject var viewModel: CreateNewClientViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @FocusState private var focusedField: CorporationClientFields?
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5) {
            
            Image(systemName: "building.columns.circle.fill")
                .font(.system(size: 130))
                .foregroundStyle(Color.brandBlack)
                .padding(.top, 20)
            
            Text("Business entity")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .padding(.bottom, 8)
            
            if isSlovak {
                Button {
                    dismissKeyboard()
                    viewModel.isShowingBIDSheet = true
                } label: {
                    Text("Fill based on BID")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandWhite)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.brandBlack)
                        .clipShape(.rect(cornerRadius: 17, style: .continuous))
                }
            }
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: Name
                VStack(alignment: .leading, spacing: 1) {
                    Text("Name")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Name of company", text: $viewModel.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .name)
                        .onSubmit { focusedField = .email }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }.padding(.top, 20)
                
                // MARK: Email
                VStack(alignment: .leading, spacing: 1) {
                    Text("Email")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Email address", text: $viewModel.email)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        .onSubmit { focusedField = .phone }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Phone
                VStack(alignment: .leading, spacing: 1) {
                    Text("Phone number")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Number", text: $viewModel.phone)
                        .font(.system(size: 22, weight: .semibold))
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
                    Text("Street")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Street", text: $viewModel.street)
                        .font(.system(size: 22, weight: .semibold))
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
                    Text("Additional info")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("App #, Suite (optional)", text: $viewModel.secondRowStreet)
                        .font(.system(size: 22, weight: .semibold))
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
                    Text("City")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("City", text: $viewModel.city)
                        .font(.system(size: 22, weight: .semibold))
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
                    Text("Postal code")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("ZIP Code", text: $viewModel.postalCode)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .postalCode)
                        .onSubmit { focusedField = .country }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(isCzechoSlovak ? .numberPad : .default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Country
                VStack(alignment: .leading, spacing: 1) {
                    Text("Country")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Country", text: $viewModel.country)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .focused($focusedField, equals: .country)
                        .onSubmit { focusedField = .businessID }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: - Business Additions
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: BusinessID
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("Business ID")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("BID", text: $viewModel.businessID)
                            .font(.system(size: 22, weight: .semibold))
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
                        
                        Text("Tax ID")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("TID", text: $viewModel.taxID)
                            .font(.system(size: 22, weight: .semibold))
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
                        
                        Text("VAT Registration Number")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("VAT ID", text: $viewModel.vatRegistrationNumber)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .focused($focusedField, equals: .vatRegistrationNumber)
                            .onSubmit { focusedField = .contactPersonName }
                            .submitLabel(.continue)
                            .multilineTextAlignment(.leading)
                            .textInputAutocapitalization(.characters)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                    // MARK: ContactPersonName
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("Contact person")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("Name and surname", text: $viewModel.contactPersonName)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .focused($focusedField, equals: .contactPersonName)
                            .onSubmit {
                                dismissKeyboard()
                                if let createdClient = viewModel.createNewClient(clientType: .corporation) {
                                    dismiss()
                                    behaviourVM.clientsPath.append(createdClient)
                                }
                            }
                            .submitLabel(.done)
                            .submitLabel(.continue)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                    }
                    
                    
                }
                
                Button {
                    dismissKeyboard()
                    if let createdClient = viewModel.createNewClient(clientType: .corporation) {
                        dismiss()
                        behaviourVM.clientsPath.append(createdClient)
                    }
                } label: {
                    Text("Add client")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.brandWhite)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.name.isEmpty ? Color.brandGray : Color.brandBlack)
                        .clipShape(Capsule())
                }.padding(.top, 15)
                    .disabled(viewModel.name.isEmpty)
                
            }.padding(.horizontal, 15)
            
        }.onAppear { focusedField = .name }
            .sheet(isPresented: $viewModel.isShowingBIDSheet) {
                BIDFillSheet(viewModel: viewModel)
            }
            .background{ Color.brandWhite.onTapGesture { dismissKeyboard() } }
    }
    
}
