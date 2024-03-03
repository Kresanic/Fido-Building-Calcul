//
//  PenetrationCoat+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData

@objc(PenetrationCoat)
public class PenetrationCoat: NSManagedObject {
    
    public var area: Double {
        
        let wallArea = width * height
        return max(wallArea, 0)
        
    }

}
