//
//  Wiring+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(Wiring)
public class Wiring: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Wiring"
    
    static var subTitle: LocalizedStringKey =  "switch, socket, light, connection point..."
    
    static var priceListSubTitle: LocalizedStringKey = "outlet"
    
    static var unit: UnitsOfMeasurment  = .piece
    
}
