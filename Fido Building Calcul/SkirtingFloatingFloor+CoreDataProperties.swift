//
//  SkirtingFloatingFloor+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension SkirtingFloatingFloor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkirtingFloatingFloor> {
        return NSFetchRequest<SkirtingFloatingFloor>(entityName: "SkirtingFloatingFloor")
    }

    @NSManaged public var basicMeter: Int64
    @NSManaged public var fromRoom: Room?

}

extension SkirtingFloatingFloor : Identifiable {

}
