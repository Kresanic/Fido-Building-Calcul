//
//  PlasterboardingCeiling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData

@objc(PlasterboardingCeiling)
public class PlasterboardingCeiling: NSManagedObject, AreaBasedWorkType {
        
    var title: String = "Sádrokartón"
    
    var subTitle: String = "strop"
    
    var unit: UnitsOfMeasurment = .squareMeter
    
    public var associatedWindows: [Window] {
        
        let set = containsWindows as? Set<Window> ?? []
        
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }

}
