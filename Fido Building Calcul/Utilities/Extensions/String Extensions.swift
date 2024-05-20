//
//  String Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/05/2024.
//

import Foundation

extension String {
    
    var toDouble: Double {
        return round((Double(self) ?? 1.0)*100)/100
    }
    
}
