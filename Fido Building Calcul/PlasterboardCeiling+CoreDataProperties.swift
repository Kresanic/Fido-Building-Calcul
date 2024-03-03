//
//  PlasterboardCeiling+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension PlasterboardCeiling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlasterboardCeiling> {
        return NSFetchRequest<PlasterboardCeiling>(entityName: "PlasterboardCeiling")
    }

    @NSManaged public var width: Int64
    @NSManaged public var length: Int64
    @NSManaged public var fromRoom: Room?
    @NSManaged public var containsWindows: NSSet?

}

// MARK: Generated accessors for containsWindows
extension PlasterboardCeiling {

    @objc(addContainsWindowsObject:)
    @NSManaged public func addToContainsWindows(_ value: Window)

    @objc(removeContainsWindowsObject:)
    @NSManaged public func removeFromContainsWindows(_ value: Window)

    @objc(addContainsWindows:)
    @NSManaged public func addToContainsWindows(_ values: NSSet)

    @objc(removeContainsWindows:)
    @NSManaged public func removeFromContainsWindows(_ values: NSSet)

}

extension PlasterboardCeiling : Identifiable {

}
