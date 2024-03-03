//
//  PlasterboardingPartition+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PlasterboardingPartition)
public class PlasterboardingPartition: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Plasterboarding"
    
    static var subTitle: LocalizedStringKey =  "partition"
    
    static var simpleBillSubTitle: LocalizedStringKey = "Plasterboarding, simple"
    static var doubleBillSubTitle: LocalizedStringKey = "Plasterboarding, double"
    static var tripleBillSubTitle: LocalizedStringKey = "Plasterboarding, triple"
    
    static var simpleSubTitle: LocalizedStringKey = "simple"
    static var doubleSubTitle: LocalizedStringKey = "double"
    static var tripleSubTitle: LocalizedStringKey = "triple"
    
    static var unit: UnitsOfMeasurment  = .squareMeter
    
    public var cleanArea: Double {
        
        let windowsAndDoorsArea = associatedDoors.reduce(0.0, { $0 + $1.area }) + associatedWindows.reduce(0.0, { $0 + $1.area })
        
        return area - windowsAndDoorsArea
        
    }
    
    public var associatedDoors: [Door] {
        
        let set = containsDoors as? Set<Door> ?? []
        
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedWindows: [Window] {
        
        let set = containsWindows as? Set<Window> ?? []
        
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
}
