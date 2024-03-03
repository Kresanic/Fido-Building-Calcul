//
//  Grouting+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension Grouting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grouting> {
        return NSFetchRequest<Grouting>(entityName: "Grouting")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var length: Double
    @NSManaged public var width: Double
    @NSManaged public var fromRoom: Room?

}

extension Grouting : Identifiable {

}
