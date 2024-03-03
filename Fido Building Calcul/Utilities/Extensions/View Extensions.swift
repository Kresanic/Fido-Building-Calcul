//
//  View Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

extension View {
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func doubleToString(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
    func stringToDouble(from text: String) -> Double {
        
        return calculate(on: text)
    }
    
    private func calculate(on expressionString: String) -> Double {
        
        guard let _ = Int(expressionString.suffix(1)) else { return 0.0 }
        guard let _ = Int(expressionString.prefix(1)) else { return 0.0 }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
                
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return 0.0 }
        
        return result
        
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
       let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
}
