//
//  TileCeramic+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(TileCeramic)
public class TileCeramic: NSManagedObject, AreaBasedWorkType {
    
    static var title: LocalizedStringKey = "Tiling under 60cm"
    
    static var subTitle: LocalizedStringKey = "ceramicTiling"
    
    static var billSubTitle: LocalizedStringKey = "Tiling, ceramic"
    
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
