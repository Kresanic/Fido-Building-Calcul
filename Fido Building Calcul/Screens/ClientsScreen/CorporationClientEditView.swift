//
//  CorporationClientEditView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/08/2023.
//

import SwiftUI

struct CorporationClientEditView: View {
    
    var client: Client
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CreateNewClientViewModel
    
    var body: some View {
        
        ScrollView {
            
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: Title and Settings Gear
            HStack {
                Text("Informácie")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .padding(.bottom, -5)
                
                Spacer()
            }
            
            // MARK: Name
            VStack(alignment: .leading, spacing: 1) {
                Text("Meno")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("Názov firmy", text: $viewModel.name)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
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
                    .multilineTextAlignment(.leading)
                    .keyboardType(.phonePad)
                    .frame(maxWidth: .infinity)
            }
            
            // MARK: Street
            VStack(alignment: .leading, spacing: 1) {
                Text("Ulica")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("Ulica a číslo budovy", text: $viewModel.street)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
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
                    .multilineTextAlignment(.leading)
                    .keyboardType(.default)
                    .frame(maxWidth: .infinity)
            }
            
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
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    viewModel.createNewClient(clientType: .corporation)
                } label: {
                    Text("Uložiť klienta")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.brandWhite)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.name.isEmpty ? Color.brandGray : Color.brandBlack)
                        .clipShape(Capsule())
                }.padding(.top, 15)
                    .disabled(viewModel.name.isEmpty)
                
            }
            
            
        }/*.padding(.horizontal, 15).padding(.bottom, 105).onAppear { loadClient() }*/
            
        }.scrollDismissesKeyboard(.immediately)
            .toolbar(.hidden, for: .bottomBar)
        
    }
    
//    func loadClient() {
//        
//        name                      = client.name ?? ""
//        street                = client.street ?? ""
//        secondRowStreet       = client.secondRowStreet ?? ""
//        city                  = client.city ?? ""
//        postalCode            = client.postalCode ?? ""
//        country               = client.country ?? ""
//        email                 = client.email ?? ""
//        phone                 = client.phone ?? ""
//        businessID            = client.businessID ?? ""
//        taxID                 = client.taxID ?? ""
//        vatRegistrationNumber = client.vatRegistrationNumber ?? ""
//        contactPersonName     = client.contactPersonName ?? ""
//        
//    }
//    
//    func createNewClient() {
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
//            guard !name.isEmpty else { return }
//            
//            client.name = name
//            client.street = street
//            client.secondRowStreet = secondRowStreet
//            client.city = city
//            client.postalCode = postalCode
//            client.country = country
//            client.email = email
//            client.phone = phone
//            client.businessID = businessID
//            client.taxID = taxID
//            client.vatRegistrationNumber = vatRegistrationNumber
//            client.contactPersonName = contactPersonName
//            
//            do {
//                try viewContext.save()
//                dismiss()
//            } catch { return }
//        }
//    }
    
}
