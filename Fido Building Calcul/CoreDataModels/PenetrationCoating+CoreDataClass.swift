//
//  PenetrationCoating+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PenetrationCoating)
public class PenetrationCoating: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Penetration coating"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurement  = .squareMeter
    
}
