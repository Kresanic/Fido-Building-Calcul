//
//  Siliconing+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(Siliconing)
public class Siliconing: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Siliconing"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurment  = .basicMeter
    
}
