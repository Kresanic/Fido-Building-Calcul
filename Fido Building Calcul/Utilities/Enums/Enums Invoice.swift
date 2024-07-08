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
