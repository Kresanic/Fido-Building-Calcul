//
//  InstallationOfSanitary+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension InstallationOfSanitary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstallationOfSanitary> {
        return NSFetchRequest<InstallationOfSanitary>(entityName: "InstallationOfSanitary")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var pieces: Double
    @NSManaged public var type: String?
    @NSManaged public var fromRoom: Room?

}

extension InstallationOfSanitary : Identifiable {

}
