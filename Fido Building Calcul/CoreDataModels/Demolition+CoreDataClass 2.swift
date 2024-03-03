//
//  Demolition+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(Demolition)
public class Demolition: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Búracie práce"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .piece
    
    
}
