//
//  Plumbing+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(Plumbing)
public class Plumbing: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Vodoinštalatérske práce"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .piece
    
}
