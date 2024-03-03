//
//  ContractorEditDetailsView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI
import PhotosUI

struct ContractorEditDetailsView: View {
    
    @ObservedObject var viewModel: ContractorViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @FocusState private var focusedField: UserFields?
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    var contractor: Contractor?
    var isSlovak: Bool { (locale.identifier.hasPrefix("sk") || locale.identifier.hasPrefix("cz")) ? true : false }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5) {
            
            // MARK: - Logo Input
            Button {
                dismissKeyboard()
                viewModel.isSelectingLogo = true
            } label: {
                HStack {
                    
                    Spacer()
                    
                    Spacer().frame(width: 40)
                    
                    if let imageData = viewModel.imageData, let logo =  UIImage(data: imageData)  {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .clipShape(.rect(cornerRadius: 10, style: .continuous))
                    } else {
                        Image(systemName: "building.columns.circle.fill")
                            .font(.system(size: 125))
                            .foregroundStyle(Color.brandBlack)
                    }
                    
                    Image(systemName: "square.and.pencil.circle.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 40, alignment: .trailing)
                    
                    Spacer()
                    
                }
                
            }.padding(.top, 20)
            
            Text("Contractor details")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .padding(.vertical, 10)
            
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
                        .onSubmit { focusedField = .contactPersonName }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
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
                        .onSubmit { focusedField = .email }
                        .submitLabel(.done)
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
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
                        .onSubmit { focusedField = .web }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.phonePad)
                        .frame(maxWidth: .infinity)
                }
                
                // MARK: Web
                VStack(alignment: .leading, spacing: 1) {
                    Text("Web page")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    TextField("Link", text: $viewModel.web)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .web)
                        .onSubmit { focusedField = .street }
                        .submitLabel(.continue)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.URL)
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
                        .keyboardType(isSlovak ? .numberPad : .default)
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
                            .onSubmit { focusedField = .bankAccountNumber }
                            .submitLabel(.continue)
                            .multilineTextAlignment(.leading)
                            .textInputAutocapitalization(.characters)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                
                // MARK: - Financial and Legal Additions
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Bank Account Number
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("Bank account number")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("Number", text: $viewModel.bankAccountNumber)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .focused($focusedField, equals: .bankAccountNumber)
                            .onSubmit { focusedField = .bankCode }
                            .submitLabel(.continue)
                            .multilineTextAlignment(.leading)
                            .textInputAutocapitalization(.characters)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // MARK: Bank Code
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("Bank Code")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("Code", text: $viewModel.swiftCode)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .focused($focusedField, equals: .bankCode)
                            .onSubmit { focusedField = .legalNote }
                            .submitLabel(.continue)
                            .multilineTextAlignment(.leading)
                            .textInputAutocapitalization(.characters)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // MARK: Legal appendix
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("Legal appendix")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        TextField("Note", text: $viewModel.legalNotice)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .focused($focusedField, equals: .legalNote)
                            .submitLabel(.done)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                
                Button {
                    dismissKeyboard()
                    if let _ = viewModel.createUser() { dismiss() }
                } label: {
                    Text("Save")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.brandWhite)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.name.isEmpty ? Color.brandGray : Color.brandBlack)
                        .clipShape(Capsule())
                }.padding(.vertical, 15)
                    .disabled(viewModel.name.isEmpty)
                
            }.padding(.horizontal, 15)
            
        }.onAppear { focusedField = .name }
            .background { Color.brandWhite.onTapGesture{ dismissKeyboard() } }
            .onChange(of: viewModel.selectedImages) { _ in
                Task {
                    if let loaded = try? await viewModel.selectedImages.first?.loadTransferable(type: Data.self) {
                        viewModel.imageData = loaded
                    } else {
                        print("Failed to load Image Data.")
                    }
                }
            }
            .photosPicker(isPresented: $viewModel.isSelectingLogo, selection: $viewModel.selectedImages, maxSelectionCount: 1, matching: .images)
    }
    
}
