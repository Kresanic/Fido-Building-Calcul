//
//  Invoice+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//
//

import Foundation
import CoreData


public class Invoice: NSManagedObject {
    
    var stringNumber: String {
        String(number)
    }

    var statusCase: InvoiceStatus {
        
        let currentCase = InvoiceStatus(rawValue: status ?? "unpaid") ?? .unpaid
        
        let maturityCutOff = Calendar.current.date(byAdding: .day, value: Int(maturityDays), to: dateCreated ?? Date.now) ?? Date.now
        
        if Date.now > maturityCutOff && currentCase == .unpaid {
            return .afterMaturity
        } else {
            return currentCase
        }
        
    }
    
}
