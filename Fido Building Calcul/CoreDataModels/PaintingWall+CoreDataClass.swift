//
//  PaintingWall+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PaintingWall)
public class PaintingWall: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Painting"
    
    static var subTitle: LocalizedStringKey =  "wall, 2 layers"
    
    static var billSubTitle: LocalizedStringKey = "Painting, wall"
    
    static var unit: UnitsOfMeasurement  = .squareMeter

}
