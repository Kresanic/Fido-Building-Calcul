//
//  Scaffolding+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 25/04/2024.
//
//

import SwiftUI
import CoreData


public class Scaffolding: NSManagedObject, AreaBasedOtherType {
    
    static var title: LocalizedStringKey = "Scaffolding"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .squareMeter

}


public class ScaffoldingAssemblyAndDisassembly: OtherType {
    
    static var title: LocalizedStringKey = "Scaffolding"
    static var subTitle: LocalizedStringKey = "assembly and disassembly"
    static var billTitle: LocalizedStringKey = "Scaffolding - assembly and disassembly"
    static var unit: UnitsOfMeasurement = .squareMeter
    
}
