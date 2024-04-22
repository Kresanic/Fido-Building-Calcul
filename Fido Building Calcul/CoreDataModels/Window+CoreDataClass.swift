//
//  Window+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//


import CoreData
import SwiftUI

@objc(Window)
public class Window: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Window"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurement  = .piece
    
    
}
