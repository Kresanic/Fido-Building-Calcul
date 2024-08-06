//
//  Plumbing+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(Plumbing)
public class Plumbing: NSManagedObject, CountBasedWorkType {
    
    static var title: LocalizedStringKey = "Plumbing"
    
    static var subTitle: LocalizedStringKey =  "hot, cold, waste, connection point"
    
    static var priceListSubTitle: LocalizedStringKey = "outlet"
    
    static var unit: UnitsOfMeasurement  = .piece
    
}
