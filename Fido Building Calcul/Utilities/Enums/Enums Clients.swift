//
//  Enums Clients.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import Foundation

enum ClientType: String, CaseIterable { case personal, corporation }

enum PersonalClientFields { case name, email, phone, street, secondRowStreet, city, postalCode, country }

enum CorporationClientFields { case name, email, phone, street, secondRowStreet, city, postalCode, country, vatRegistrationNumber, taxID, businessID, contactPersonName }
