//
//  PlasteringOfWindowSash+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(PlasteringOfWindowSash)
public class PlasteringOfWindowSash: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Omietka špalety"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .basicMeter
    

}
