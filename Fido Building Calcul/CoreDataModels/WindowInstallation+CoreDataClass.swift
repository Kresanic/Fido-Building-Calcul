//
//  WindowInstallation+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(WindowInstallation)
public class WindowInstallation: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Window installation"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurment  = .basicMeter
    

}
