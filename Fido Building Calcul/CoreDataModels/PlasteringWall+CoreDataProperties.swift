//
//  PlasteringWall+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension PlasteringWall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlasteringWall> {
        return NSFetchRequest<PlasteringWall>(entityName: "PlasteringWall")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var containsDoors: NSSet?
    @NSManaged public var containsWindows: NSSet?
    @NSManaged public var fromRoom: Room?

}

// MARK: Generated accessors for containsDoors
extension PlasteringWall {

    @objc(addContainsDoorsObject:)
    @NSManaged public func addToContainsDoors(_ value: Door)

    @objc(removeContainsDoorsObject:)
    @NSManaged public func removeFromContainsDoors(_ value: Door)

    @objc(addContainsDoors:)
    @NSManaged public func addToContainsDoors(_ values: NSSet)

    @objc(removeContainsDoors:)
    @NSManaged public func removeFromContainsDoors(_ values: NSSet)

}

// MARK: Generated accessors for containsWindows
extension PlasteringWall {

    @objc(addContainsWindowsObject:)
    @NSManaged public func addToContainsWindows(_ value: Window)

    @objc(removeContainsWindowsObject:)
    @NSManaged public func removeFromContainsWindows(_ value: Window)

    @objc(addContainsWindows:)
    @NSManaged public func addToContainsWindows(_ values: NSSet)

    @objc(removeContainsWindows:)
    @NSManaged public func removeFromContainsWindows(_ values: NSSet)

}

extension PlasteringWall : Identifiable {

}
