//
//  Enums Invoice.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/04/2024.
//

import Foundation

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

