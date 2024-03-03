//
//  BricklayingOfLoadBearingMasonry+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData

@objc(BricklayingOfLoadBearingMasonry)
public class BricklayingOfLoadBearingMasonry: NSManagedObject {
    
    public var associatedWindows: [Window] {
    
        let set = containsWindows as? Set<Window> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedDoors: [Door] {
    
        let set = containsDoors as? Set<Door> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var area: Double {
        
        let wallArea = width * height
        let doorArea = max(associatedDoors.reduce(0.0, { $0 + $1.area }), 0)
        let windowArea = max(associatedWindows.reduce(0.0, { $0 + $1.area }), 0)
        let totalArea = (wallArea - doorArea) - windowArea
        return max(totalArea, 0)
        
    }
    
    public var windowsAndDoorsCircumeference: Double {
        
        let windowsCirc = associatedWindows.reduce(0.0, { $0 + $1.height + $1.width})
        let doorsCirc = associatedDoors.reduce(0.0, { $0 + $1.height + $1.width})
        
        return windowsCirc + doorsCirc
        
    }
    
}
