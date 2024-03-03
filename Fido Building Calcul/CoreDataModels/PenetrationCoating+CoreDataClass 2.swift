//
//  PenetrationCoating+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(PenetrationCoating)
public class PenetrationCoating: NSManagedObject, AreaBasedWorkType {
    
    var title: String = "Penetračný náter"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .squareMeter
    
}
