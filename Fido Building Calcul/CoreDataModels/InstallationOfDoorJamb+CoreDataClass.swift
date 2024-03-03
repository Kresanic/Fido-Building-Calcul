//
//  InstallationOfDoorJamn+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(InstallationOfDoorJamn)
public class InstallationOfDoorJamb: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Installation of door jamb"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurment  = .piece

}
