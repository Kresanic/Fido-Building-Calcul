//
//  CoreDrill+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 25/04/2024.
//
//

import CoreData
import SwiftUI


public class CoreDrill: NSManagedObject, CountBasedOtherType {
    
    static var title: LocalizedStringKey = "Core Drill"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .hour
    

}
