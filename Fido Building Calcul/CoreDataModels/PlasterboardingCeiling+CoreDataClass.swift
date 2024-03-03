//
//  PlasterboardingCeiling+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(PlasterboardingCeiling)
public class PlasterboardingCeiling: NSManagedObject, AreaBasedWorkType {
        
    static var title: LocalizedStringKey = "Plasterboarding"
    
    static var subTitle: LocalizedStringKey =  "ceiling"
    
    static var billSubTitle: LocalizedStringKey = "Plasterboarding, ceiling"
    
    static var unit: UnitsOfMeasurment  = .squareMeter
    
    public var cleanArea: Double {
        
        let windowsAndDoorsArea = associatedWindows.reduce(0.0, { $0 + $1.area })
        
        return area - windowsAndDoorsArea
        
    }
    
    public var associatedWindows: [Window] {
        
        let set = containsWindows as? Set<Window> ?? []
        
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }

}
