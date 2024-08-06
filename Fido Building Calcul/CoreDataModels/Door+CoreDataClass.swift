//
//  Door+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//


import CoreData
import SwiftUI

@objc(Door)
public class Door: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Door"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurement  = .piece
    
}
