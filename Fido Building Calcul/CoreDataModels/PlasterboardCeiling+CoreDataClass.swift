//
//  PlasterboardCeiling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData

@objc(PlasterboardCeiling)
public class PlasterboardCeiling: NSManagedObject {
    
    public var associatedWindows: [Window] {
    
        let set = containsWindows as? Set<Window> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var area: Double {
        
        let wallArea = width * length
        let windowArea = max(associatedWindows.reduce(0.0, { $0 + $1.area }), 0)
        let totalArea = wallArea - windowArea
        return max(totalArea, 0)
        
    }
    
}
