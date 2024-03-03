//
//  ClientEditViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/09/2023.
//

import SwiftUI
import CoreData

@MainActor final class ClientEditViewModel: ObservableObject {
    
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
        
    func hasProgressBeenMade(client: Client) -> Bool {
        if
            name != client.name ||
            street != client.street ||
            secondRowStreet != client.secondRowStreet ||
            city != client.city ||
            postalCode != client.postalCode ||
            country != client.country ||
            email != client.email ||
            phone != client.phone ||
            vatRegistrationNumber != client.vatRegistrationNumber ||
            taxID != client.taxID ||
            businessID != client.businessID ||
            contactPersonName != client.contactPersonName
        {
            return true
        }
        else {
            return false
        }
        
    }
    
    func loadClient(_ client: Client) {

        name                  = client.name ?? ""
        street                = client.street ?? ""
        secondRowStreet       = client.secondRowStreet ?? ""
        city                  = client.city ?? ""
        postalCode            = client.postalCode ?? ""
        country               = client.country ?? ""
        email                 = client.email ?? ""
        phone                 = client.phone ?? ""
        businessID            = client.businessID ?? ""
        taxID                 = client.taxID ?? ""
        vatRegistrationNumber = client.vatRegistrationNumber ?? ""
        contactPersonName     = client.contactPersonName ?? ""

    }
    
    func createNewClient(client: Client) -> Bool {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        return withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
            
            guard !name.isEmpty else { return false }
            
            client.name = name
            client.street = street
            client.secondRowStreet = secondRowStreet
            client.city = city
            client.postalCode = postalCode
            client.country = country
            client.email = email
            client.phone = phone
            client.taxID = taxID
            client.businessID = businessID
            client.vatRegistrationNumber = vatRegistrationNumber
            client.contactPersonName = contactPersonName
            
            do {
                try viewContext.save()
            } catch {
                return false
            }
            
            return true
        }
    }
    
}
