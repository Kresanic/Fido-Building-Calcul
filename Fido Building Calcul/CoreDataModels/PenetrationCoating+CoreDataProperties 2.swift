//
//  PenetrationCoating+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension PenetrationCoating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PenetrationCoating> {
        return NSFetchRequest<PenetrationCoating>(entityName: "PenetrationCoating")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var height: Double
    @NSManaged public var width: Double
    @NSManaged public var fromRoom: Room?

}

extension PenetrationCoating : Identifiable {

}
