//
//  FloatingFloorLaying+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData

@objc(FloatingFloorLaying)
public class FloatingFloorLaying: NSManagedObject {
    
    public var area: Double {
        
        let wallArea = width * length
        return max(wallArea, 0)
        
    }

}
