//
//  SkirtingOfFloatingFloor+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension SkirtingOfFloatingFloor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkirtingOfFloatingFloor> {
        return NSFetchRequest<SkirtingOfFloatingFloor>(entityName: "SkirtingOfFloatingFloor")
    }

    @NSManaged public var basicMeter: Double
    @NSManaged public var dateCreated: Date?
    @NSManaged public var fromRoom: Room?

}

extension SkirtingOfFloatingFloor : Identifiable {

}
