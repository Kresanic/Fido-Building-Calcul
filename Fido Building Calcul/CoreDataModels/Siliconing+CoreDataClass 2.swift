//
//  Siliconing+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(Siliconing)
public class Siliconing: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Silikónovanie"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .basicMeter
    

}
