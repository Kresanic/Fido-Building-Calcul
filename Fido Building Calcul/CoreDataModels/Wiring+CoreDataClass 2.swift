//
//  Wiring+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(Wiring)
public class Wiring: NSManagedObject, CountBasedWorkType {
    
    var title: String = "Elektroinštalatérske práce"
    
    var subTitle: String = "vypínač, zásuvka, svetlo, bod napojenia"
    
    var unit: UnitsOfMeasurment = .piece
    

}
