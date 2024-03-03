//
//  SkirtingOfFloatingFloor+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(SkirtingOfFloatingFloor)
public class SkirtingOfFloatingFloor: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Lištovanie"
    
    var subTitle: String = "plávajúca podlaha"
    
    var unit: UnitsOfMeasurment = .basicMeter
    

}
