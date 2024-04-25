//
//  Scaffolding+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 25/04/2024.
//
//

import SwiftUI
import CoreData


public class Scaffolding: NSManagedObject, AreaBasedOtherType {
    
    static var title: LocalizedStringKey = "Scaffolding"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .squareMeter

}
