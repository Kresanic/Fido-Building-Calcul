//
//  Date Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 03/04/2024.
//

import Foundation

extension Date {
    
    var iso8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    var startOfTheDay: Date {
        
        let calendar = Calendar.current
        
        let startOfTheDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)
        
        return startOfTheDay ?? self
        
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}
