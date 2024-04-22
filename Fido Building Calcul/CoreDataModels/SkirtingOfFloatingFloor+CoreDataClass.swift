//
//  SkirtingOfFloatingFloor+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(SkirtingOfFloatingFloor)
public class SkirtingOfFloatingFloor: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Skirting"
    
    static var subTitle: LocalizedStringKey =  "floating floor"
    
    static var unit: UnitsOfMeasurement  = .basicMeter
    
}
