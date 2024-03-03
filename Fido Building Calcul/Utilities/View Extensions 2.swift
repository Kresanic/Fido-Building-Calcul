//
//  View Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

extension View {
    
    func slovakTranslation(propertycategory: PropertyCategories) -> String {
        switch propertycategory {
        case .flats:
            return "Byty"
        case .houses:
            return "Domy"
        case .cottages:
            return "Chaty"
        case .firms:
            return "Firmy"
        }
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
    }
    
    func doubleToString(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
    func stringToDouble(from text: String) -> Double {
        let textWithDot = text.replacingOccurrences(of: ",", with: ".")
        return Double(textWithDot) ?? 0.0
    }
    
}


