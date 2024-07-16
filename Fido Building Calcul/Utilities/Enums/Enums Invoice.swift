//
//  Enums Invoice.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/04/2024.
//

import SwiftUI

enum MaturityDuration: Int, CaseIterable {
    
    case week = 7
    case biWeek = 15
    case month = 30
    case twoMonths = 60
    case threeMonths = 90
    
    
    static func isOneOfTheCases(_ num: Int) -> Bool {
        
        for duration in Self.allCases {
            if duration.rawValue == num {
                return true
            }
        }
        
        return false
        
    }
    
}


enum InvoiceStatus: String, CaseIterable {
    
    case paid, unpaid, afterMaturity
    
    var name: LocalizedStringKey {
        switch self {
        case .paid:
            "Paid"
        case .unpaid:
            "Unpaid"
        case .afterMaturity:
            "After Maturity"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .paid:
            Color.brandGreen
        case .unpaid:
            Color.brandBlue
        case .afterMaturity:
            Color.brandRed
        }
    }
    
    var bubble: some View {
        
        Text(self.name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.brandWhite)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(self.backgroundColor)
            .clipShape(.capsule)
        
    }
    
    var bigBubble: some View {
        
        Text(self.name)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.brandWhite)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(self.backgroundColor)
            .clipShape(.capsule)
        
    }
    
}

enum BuilderFocused { case number, note }

enum InvoiceBuilderItemFocuses {
    
    case count, pricePerPiece, VAT, withoutVAT, textField
    
    var advance: Self? {
        switch self {
        case .count:
            .pricePerPiece
        case .pricePerPiece:
            .VAT
        case .VAT:
            .withoutVAT
        case .withoutVAT:
            nil
        case .textField:
            nil
        }
    }
    
}

enum InvoiceItemCategory { case work, material, other }

enum PaymentType: String {
    
    case cash, bankTransfer
    
    var title: LocalizedStringKey {
        switch self {
        case .cash:
            "Cash"
        case .bankTransfer:
            "Bank transfer"
        }
    }
    
}

enum ContractorValues: String, InvoiceMissingValue {
    
    var id: String { self.rawValue }
    
    case vatRegistrationNumber, taxID, street, postalCode, name, country, city, businessID, bankAccountNumber, email, logo, phone, signature, swiftCode
    
    var title: LocalizedStringKey {
        switch self {
        case .vatRegistrationNumber:
            "VAT Registration Number"
        case .taxID:
            "Tax ID"
        case .street:
            "Street"
        case .postalCode:
            "Postal code"
        case .name:
            "Name"
        case .country:
            "Country"
        case .city:
            "City"
        case .businessID:
            "Business ID"
        case .bankAccountNumber:
            "Bank Account Number"
        case .email:
            "Email"
        case .logo:
            "Logo"
        case .phone:
            "Phone number"
        case .signature:
            "Signature"
        case .swiftCode:
            "Bank Code"
        }
    }
}

enum ClientValues: String, InvoiceMissingValue {
    
    var id: String { self.rawValue }
    
    case vatRegistrationNumber, taxID, street, postalCode, name, country, city, businessID
    
    var title: LocalizedStringKey {
        switch self {
        case .vatRegistrationNumber:
            "VAT Registration Number"
        case .taxID:
            "Tax ID"
        case .street:
            "Street"
        case .postalCode:
            "Postal code"
        case .name:
            "Name"
        case .country:
            "Country"
        case .city:
            "City"
        case .businessID:
            "Business ID"
        }
    }
    
}

enum InvoiceValues: String, InvoiceMissingValue {
    
    var id: String { self.rawValue }
    
    case priceWithoutVAT, cumulativeVAT, number, invoiceItems, contractor, client, incorrectNumberFormat, numberAlreadyInUse
    
    var title: LocalizedStringKey {
        switch self {
        case .priceWithoutVAT:
            "Error with calculating Price"
        case .cumulativeVAT:
            "Error with calculating VAT"
        case .number:
            "Could not generate Invoice Number"
        case .invoiceItems:
            "No Items to be displayed"
        case .contractor:
            "No Contractor Assigned to this Project"
        case .client:
            "No Client Assigned to this Project"
        case .incorrectNumberFormat:
            "Incorrect Invoice Number Format"
        case .numberAlreadyInUse:
            "Invoice Number already In Use"
        }
    }
    
}
