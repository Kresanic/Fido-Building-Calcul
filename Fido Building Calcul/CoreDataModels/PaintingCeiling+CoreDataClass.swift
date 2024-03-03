//
//  PaintingCeiling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PaintingCeiling)
public class PaintingCeiling: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Painting"
    
    static var subTitle: LocalizedStringKey =  "ceiling, 2 layers"
    
    static var billSubTitle: LocalizedStringKey = "Painting, ceiling"
    
    static var unit: UnitsOfMeasurment  = .squareMeter

}
