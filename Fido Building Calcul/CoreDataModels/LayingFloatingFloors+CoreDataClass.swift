//
//  LayingFloatingFloors+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(LayingFloatingFloors)
public class LayingFloatingFloors: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Floating floor"
    
    static var subTitle: LocalizedStringKey =  "laying"
    
    static var billSubTitle: LocalizedStringKey = "Laying of floating floor"
    
    static var unit: UnitsOfMeasurement  = .squareMeter
    
    public var circurmference: Double {
        
        return size1*2 + size2*2
        
    }
    
}
