//
//  ContractorDetailViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI
import PhotosUI

@MainActor final class ContractorDetailViewModel: ObservableObject {
    
    @Published var isSelectingLogo = false
    @Published var user: Contractor? {
        didSet {
            if let user {
                loadClient(user)
            }
        }
    }
    @Published var name = ""
    @Published var street = ""
    @Published var secondRowStreet = ""
    @Published var city = ""
    @Published var postalCode = ""
    @Published var country = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var vatRegistrationNumber = ""
    @Published var taxID = ""
    @Published var businessID = ""
    @Published var contactPersonName = ""
    @Published var bankAccountNumber = ""
    @Published var legalNotice = ""
    @Published var swiftCode = ""
    @Published var web = ""
    @Published var selectedImages: [PhotosPickerItem] = []
    @Published var imageData: Data?
    
    func loadClient(_ contractor: Contractor) {
        
        name                  = contractor.name ?? ""
        street                = contractor.street ?? ""
        secondRowStreet       = contractor.secondRowStreet ?? ""
        city                  = contractor.city ?? ""
        postalCode            = contractor.postalCode ?? ""
        country               = contractor.country ?? ""
        email                 = contractor.email ?? ""
        phone                 = contractor.phone ?? ""
        businessID            = contractor.businessID ?? ""
        taxID                 = contractor.taxID ?? ""
        vatRegistrationNumber = contractor.vatRegistrationNumber ?? ""
        contactPersonName     = contractor.contactPersonName ?? ""
        bankAccountNumber     = contractor.bankAccountNumber ?? ""
        legalNotice           = contractor.legalNotice ?? ""
        swiftCode             = contractor.swiftCode ?? ""
        web                   = contractor.web ?? ""
        
        imageData             = contractor.logo
        
    }
        
    func hasProgressBeenMade() -> Bool {
        
        if let user = self.user {
            guard
                user.name == name,
                user.street == street,
                user.secondRowStreet == secondRowStreet,
                user.city == city,
                user.postalCode == postalCode,
                user.country == country,
                user.email == email,
                user.phone == phone,
                user.taxID == taxID,
                user.businessID == businessID,
                user.vatRegistrationNumber == vatRegistrationNumber,
                user.contactPersonName == contactPersonName,
                user.bankAccountNumber == bankAccountNumber,
                user.legalNotice == legalNotice,
                user.swiftCode == swiftCode,
                user.web == web
            else {
                return true
            }
        } else {
            guard
                name.isEmpty,
                street.isEmpty,
                secondRowStreet.isEmpty,
                city.isEmpty,
                postalCode.isEmpty,
                country.isEmpty,
                email.isEmpty,
                phone.isEmpty,
                vatRegistrationNumber.isEmpty,
                taxID.isEmpty,
                businessID.isEmpty,
                contactPersonName.isEmpty,
                bankAccountNumber.isEmpty,
                legalNotice.isEmpty,
                swiftCode.isEmpty,
                web.isEmpty
            else {
                return true
            }
        }
        
        return false
    }
    
    func createUser() -> Contractor? {
        
        let viewContext = PersistenceController.shared.container.viewContext
            
        guard !name.isEmpty else { return withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { return nil } }
            
            if let user = self.user {
                
                if let imageData {
                    user.logo = imageData
                }
                user.cId = UUID()
                user.dateCreated = Date.now
                user.name = name
                user.street = street
                user.secondRowStreet = secondRowStreet
                user.city = city
                user.postalCode = postalCode
                user.country = country
                user.email = email
                user.phone = phone
                user.taxID = taxID
                user.businessID = businessID
                user.vatRegistrationNumber = vatRegistrationNumber
                user.contactPersonName = contactPersonName
                user.bankAccountNumber = bankAccountNumber
                user.legalNotice = legalNotice
                user.swiftCode = swiftCode
                user.web = web
                user.logo = imageData
                
                do {
                    try viewContext.save()
                    return user
                } catch {
                    return nil
                }
                
            } else {
                
                let newUser = Contractor(context: viewContext)
                
                newUser.cId = UUID()
                newUser.dateCreated = Date.now
                newUser.name = name
                newUser.street = street
                newUser.secondRowStreet = secondRowStreet
                newUser.city = city
                newUser.postalCode = postalCode
                newUser.country = country
                newUser.email = email
                newUser.phone = phone
                newUser.taxID = taxID
                newUser.businessID = businessID
                newUser.vatRegistrationNumber = vatRegistrationNumber
                newUser.contactPersonName = contactPersonName
                newUser.bankAccountNumber = bankAccountNumber
                newUser.legalNotice = legalNotice
                newUser.swiftCode = swiftCode
                newUser.web = web
                newUser.logo = imageData
                    
                do {
                    try viewContext.save()
                    return newUser
                } catch {
                    return nil
                }
                
            }
            
    }
    
    
    func deleteContractor() {
        let viewContext = PersistenceController.shared.container.viewContext
        withAnimation {
            if let user {
                viewContext.delete(user)
                try? viewContext.save()
            }
        }
    }
    
}

