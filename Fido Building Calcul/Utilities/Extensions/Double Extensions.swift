//
//  Double Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/09/2023.
//

import SwiftUI

extension Double {
    
    mutating func roundAndRemoveZerosFromEnd() -> String {
            let formatter = NumberFormatter()
            let number = NSNumber(value: self)
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 1
            return String(formatter.string(from: number) ?? "")
        }
    
    
}
