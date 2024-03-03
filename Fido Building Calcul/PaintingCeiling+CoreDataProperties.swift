//
//  PaintingCeiling+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension PaintingCeiling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaintingCeiling> {
        return NSFetchRequest<PaintingCeiling>(entityName: "PaintingCeiling")
    }

    @NSManaged public var width: Int64
    @NSManaged public var length: Int64
    @NSManaged public var fromRoom: Room?

}

extension PaintingCeiling : Identifiable {

}
