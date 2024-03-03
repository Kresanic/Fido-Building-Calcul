//
//  Wiring+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension Wiring {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wiring> {
        return NSFetchRequest<Wiring>(entityName: "Wiring")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var hours: Double
    @NSManaged public var fromRoom: Room?

}

extension Wiring : Identifiable {

}
