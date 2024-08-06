//
//  Scaffolding+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 25/04/2024.
//
//

import SwiftUI
import CoreData

@objc(Scaffolding)
public class Scaffolding: NSManagedObject, AreaBasedOtherType {
    
    static var title: LocalizedStringKey = "Scaffolding"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .day

}


public class ScaffoldingAssemblyAndDisassembly: OtherType {
    
    static var title: LocalizedStringKey = "Scaffolding"
    static var subTitle: LocalizedStringKey = "assembly and disassembly"
    static var billTitle: LocalizedStringKey = "Scaffolding - assembly and disassembly"
    static var unit: UnitsOfMeasurement = .squareMeter
    
}
