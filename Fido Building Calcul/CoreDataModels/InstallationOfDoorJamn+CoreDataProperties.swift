//
//  InstallationOfDoorJamn+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension InstallationOfDoorJamn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstallationOfDoorJamn> {
        return NSFetchRequest<InstallationOfDoorJamn>(entityName: "InstallationOfDoorJamn")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var pieces: Double
    @NSManaged public var fromRoom: Room?

}

extension InstallationOfDoorJamn : Identifiable {

}
