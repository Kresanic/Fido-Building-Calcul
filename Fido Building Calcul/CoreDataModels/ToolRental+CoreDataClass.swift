//
//  ToolRental+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 25/04/2024.
//
//

import CoreData
import SwiftUI

@objc(ToolRental)
public class ToolRental: NSManagedObject, CountBasedOtherType {
    
    static var title: LocalizedStringKey = "Tool rental"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .hour
    
}


