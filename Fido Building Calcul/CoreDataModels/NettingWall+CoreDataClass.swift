//
//  NettingWall+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(NettingWall)
public class NettingWall: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Netting"
    
    static var subTitle: LocalizedStringKey =  "wall"
    
    static var billSubTitle: LocalizedStringKey = "Netting, wall"
    
    static var unit: UnitsOfMeasurement  = .squareMeter
    
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
