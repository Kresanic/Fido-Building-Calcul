//
//  PlasteringOfWindowSash+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PlasteringOfWindowSash)
public class PlasteringOfWindowSash: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Plastering of window sash"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurement  = .basicMeter
    

}
