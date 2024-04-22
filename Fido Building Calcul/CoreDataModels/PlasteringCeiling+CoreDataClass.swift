//
//  PlasteringCeiling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PlasteringCeiling)
public class PlasteringCeiling: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Plastering"
    
    static var subTitle: LocalizedStringKey =  "ceiling"
    
    static var billSubTitle: LocalizedStringKey = "Plastering, ceiling"
    
    static var unit: UnitsOfMeasurement  = .squareMeter

}
