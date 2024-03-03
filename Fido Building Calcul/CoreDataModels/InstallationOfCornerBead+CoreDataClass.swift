//
//  InstallationOfCornerBead+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(InstallationOfCornerBead)
public class InstallationOfCornerBead: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Installation of corner bead"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurment  = .basicMeter

}
