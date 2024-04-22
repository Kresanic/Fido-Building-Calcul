//
//  PavingCeramic+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PavingCeramic)
public class PavingCeramic: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Paving"
    
    static var subTitle: LocalizedStringKey =  "ceramic"
    
    static var billSubTitle: LocalizedStringKey = "Paving, ceramic"
    
    static var unit: UnitsOfMeasurement  = .squareMeter
    

}
