//
//  Demolition+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(Demolition)
public class Demolition: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Preparatory and demolition works"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurement  = .hour
    
    
}
