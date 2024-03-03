//
//  FloatingFloorLaying+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension FloatingFloorLaying {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FloatingFloorLaying> {
        return NSFetchRequest<FloatingFloorLaying>(entityName: "FloatingFloorLaying")
    }

    @NSManaged public var width: Int64
    @NSManaged public var length: Int64
    @NSManaged public var fromRoom: Room?

}

extension FloatingFloorLaying : Identifiable {

}
