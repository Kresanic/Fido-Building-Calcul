//
//  BIDNetworkClasses.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/12/2023.
//

import SwiftUI

struct CompanyResult: Codable {
    
    let results: [Company]
    
    var recievedCompany: Bool {
        !results.isEmpty
    }
    
}

struct Company: Codable {
    
    let ico: String
    let dic: String
    let dicDph: String
    let companyName: String
    let address: [Address]
    
}

struct Address: Codable {
    
    let street: String
    let buildingNumber: String
    let city: String
    let zipCode: String
    let country: String
    
}
