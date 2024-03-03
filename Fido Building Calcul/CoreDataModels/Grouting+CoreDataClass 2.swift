//
//  Grouting+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(Grouting)
public class Grouting: NSManagedObject, AreaBasedWorkType {
    
    var title: String = "Špárovanie"
    
    var subTitle: String = "obkladu a dlažby"
    
    var unit: UnitsOfMeasurment = .squareMeter
    

}
