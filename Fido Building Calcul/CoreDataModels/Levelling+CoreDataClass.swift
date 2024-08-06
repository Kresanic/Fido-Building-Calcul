//
//  Levelling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(Levelling)
public class Levelling: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Levelling"
    
    static var subTitle: LocalizedStringKey =  ""
    
    static var unit: UnitsOfMeasurement  = .squareMeter

}
