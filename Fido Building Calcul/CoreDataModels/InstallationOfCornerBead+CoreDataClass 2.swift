//
//  InstallationOfCornerBead+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(InstallationOfCornerBead)
public class InstallationOfCornerBead: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Osadenie rohovej lišty"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .basicMeter

}
