//
//  Demolition+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension Demolition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Demolition> {
        return NSFetchRequest<Demolition>(entityName: "Demolition")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var hours: Double
    @NSManaged public var fromRoom: Room?

}

extension Demolition : Identifiable {

}
