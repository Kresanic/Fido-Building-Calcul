//
//  InstallationOfDoorJamn+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(InstallationOfDoorJamn)
public class InstallationOfDoorJamb: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Osadenie obložkovej zárubne"
    
    var subTitle: String = ""
    
    var unit: UnitsOfMeasurment = .piece

}
