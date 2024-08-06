//
//  NettingCeiling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(NettingCeiling)
public class NettingCeiling: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Netting"
    
    static var subTitle: LocalizedStringKey =  "ceiling"
    
    static var billSubTitle: LocalizedStringKey = "Netting, ceiling"
    
    static var unit: UnitsOfMeasurement  = .squareMeter

}

