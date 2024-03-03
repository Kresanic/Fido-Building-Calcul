//
//  CreateNewClientViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 26/09/2023.
//

import SwiftUI

@MainActor final class CreateNewClientViewModel: ObservableObject {
    
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
        
    func hasProgressBeenMade() -> Bool {
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
            contactPersonName.isEmpty
        else {
            return true
        }
        return false
    }
    
    func createNewClient(clientType: ClientType) -> Client? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        return withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
            guard !name.isEmpty else { return nil }
            
            let newClient = Client(context: viewContext)
            
            newClient.cId = UUID()
            newClient.dateCreated = Date.now
            newClient.type = clientType.rawValue
            newClient.name = name
            newClient.street = street
            newClient.secondRowStreet = secondRowStreet
            newClient.city = city
            newClient.postalCode = postalCode
            newClient.country = country
            newClient.email = email
            newClient.phone = phone
            newClient.taxID = taxID
            newClient.businessID = businessID
            newClient.vatRegistrationNumber = vatRegistrationNumber
            newClient.contactPersonName = contactPersonName
            
            do {
                try viewContext.save()
            } catch {
                return nil
            }
            return newClient
        }
    }
    
}
