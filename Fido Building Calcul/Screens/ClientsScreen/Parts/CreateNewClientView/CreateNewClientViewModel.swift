//
//  CreateNewClientViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 26/09/2023.
//

import SwiftUI

@MainActor final class CreateNewClientViewModel: ObservableObject {
    
    @Environment(\.dismiss) var dismiss
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
    @Published var isShowingBIDSheet = false
    @Published var errorMessage: LocalizedStringKey?
    @Published var isLookingForBID = false
    
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
        
        return withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
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
    
    private func getCompanyInformation(from bid: String) async throws -> Company {
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isLookingForBID = true }
        
        let countryToken = "SK"
        let token = "EtInGbevF36MQa4MWag8FaeJtpcN0QXjXFK"
        
        let url = URL(string: "https://doplnky.applypark.cz/api/ares/?token=\(token)&ico=\(bid)&country=\(countryToken)")!
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw BIDError.couldNotRetrieveCall }
        
        guard let fetchedResult = try? JSONDecoder().decode(CompanyResult.self, from: data) else { throw BIDError.noCompanyFound }
        
        if let company = fetchedResult.results.first { return company } else { throw BIDError.noCompanyFound }
        
    }
    
    private func loadRetrievedInfo(from company: Company) {
        
        businessID = company.ico
        taxID = company.dic
        vatRegistrationNumber = company.dicDph ?? ""
        name = company.companyName
        
        if let address = company.address.first {
            
            street = address.street + " " + address.buildingNumber
            city = address.city
            postalCode = address.zipCode
            country = address.country
            
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isLookingForBID = false }
        
        isShowingBIDSheet = false
        
    }
    
    private func showErrorMessage(bidError: BIDError) {
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            isLookingForBID = false
            switch bidError {
            case .noCompanyFound:
                errorMessage = LocalizedStringKey("No company was found with given BID.")
            case .couldNotRetrieveCall:
                errorMessage = LocalizedStringKey("Could not reach database.")
            case .unexpectedError:
                errorMessage = LocalizedStringKey("Something went wrong. Check internet connection or try again later.")
            }
            impactMed.impactOccurred()
        }
    }
    
    func retrieveInformation(from bid: String) {
        Task {
            do {
                let company = try await getCompanyInformation(from: bid)
                loadRetrievedInfo(from: company)
            } catch {
                if let bidError = error as? BIDError {
                    showErrorMessage(bidError: bidError)
                } else {
                    showErrorMessage(bidError: .unexpectedError)
                }
            }
        }
    }
    
}
