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
        String(number ?? 99999)
    }

}
