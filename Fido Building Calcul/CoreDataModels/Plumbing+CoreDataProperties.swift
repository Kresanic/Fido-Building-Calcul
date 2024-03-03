//
//  Plumbing+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension Plumbing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plumbing> {
        return NSFetchRequest<Plumbing>(entityName: "Plumbing")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var pieces: Double
    @NSManaged public var fromRoom: Room?

}

extension Plumbing : Identifiable {

}
