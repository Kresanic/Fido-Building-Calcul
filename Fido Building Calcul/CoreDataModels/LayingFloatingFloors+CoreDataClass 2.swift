//
//  LayingFloatingFloors+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(LayingFloatingFloors)
public class LayingFloatingFloors: NSManagedObject, AreaBasedWorkType {
    
    var title: String = "Plávajúca podlaha"
    
    var subTitle: String = "pokládka"
    
    var unit: UnitsOfMeasurment  = .squareMeter
    
}
