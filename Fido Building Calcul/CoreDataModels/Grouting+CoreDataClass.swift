//
//  Grouting+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(Grouting)
public class Grouting: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Grouting"
    
    static var subTitle: LocalizedStringKey =  "tiling and paving"
    
    static var billSubTitle: LocalizedStringKey = "Grouting, tiling and paving"
    
    static var unit: UnitsOfMeasurment  = .squareMeter
    

}
