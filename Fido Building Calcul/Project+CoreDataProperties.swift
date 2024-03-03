//
//  Project+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var archived: Bool
    @NSManaged public var archivedDate: Date?
    @NSManaged public var category: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var commuteLength: Int64
    @NSManaged public var daysInWork: Int64
    @NSManaged public var consistsOfRooms: NSSet?

}

// MARK: Generated accessors for consistsOfRooms
extension Project {

    @objc(addConsistsOfRoomsObject:)
    @NSManaged public func addToConsistsOfRooms(_ value: Room)

    @objc(removeConsistsOfRoomsObject:)
    @NSManaged public func removeFromConsistsOfRooms(_ value: Room)

    @objc(addConsistsOfRooms:)
    @NSManaged public func addToConsistsOfRooms(_ values: NSSet)

    @objc(removeConsistsOfRooms:)
    @NSManaged public func removeFromConsistsOfRooms(_ values: NSSet)

}

extension Project : Identifiable {

}
