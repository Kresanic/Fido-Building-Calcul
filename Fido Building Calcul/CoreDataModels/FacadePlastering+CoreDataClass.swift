//
//  FacadePlastering+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/04/2024.
//
//

import Foundation
import CoreData
import SwiftUI


public class FacadePlastering: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Facade Plastering"
    static var subTitle: LocalizedStringKey =  ""
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
