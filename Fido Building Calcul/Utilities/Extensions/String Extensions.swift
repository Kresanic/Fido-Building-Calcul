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
    
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
    
    var beforeCommaOrDot: String {
        if let range = range(of: ",") ?? range(of: ".") {
            return String(self[..<range.lowerBound])
        }
        return self
    }
    
}
