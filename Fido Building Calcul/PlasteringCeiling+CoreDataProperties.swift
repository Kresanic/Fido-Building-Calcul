//
//  PlasteringCeiling+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension PlasteringCeiling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlasteringCeiling> {
        return NSFetchRequest<PlasteringCeiling>(entityName: "PlasteringCeiling")
    }

    @NSManaged public var width: Int64
    @NSManaged public var length: Int64
    @NSManaged public var fromRoom: Room?

}

extension PlasteringCeiling : Identifiable {

}
