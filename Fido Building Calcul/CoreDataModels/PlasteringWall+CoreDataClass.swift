//
//  PlasteringWall+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PlasteringWall)
public class PlasteringWall: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Plastering"
    
    static var subTitle: LocalizedStringKey =  "wall"
    
    static var billSubTitle: LocalizedStringKey = "Plastering, wall"
    
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
