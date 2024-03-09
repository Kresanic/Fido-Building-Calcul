//
//  PlasterboardingOffsetWall+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 09/03/2024.
//
//

import CoreData
import SwiftUI

public class PlasterboardingOffsetWall: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Plasterboarding"
    
    static var subTitle: LocalizedStringKey = "offset wall"
    
    static var simpleBillSubTitle: LocalizedStringKey = "Offset wall, simple"
    static var doubleBillSubTitle: LocalizedStringKey = "Offset wall, double"
    
    static var simpleSubTitle: LocalizedStringKey = "offset wall, simple"
    static var doubleSubTitle: LocalizedStringKey = "offset wall, double"
    
    static var unit: UnitsOfMeasurment = .squareMeter
    
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
