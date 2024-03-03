//
//  InstallationOfLinedDoorFrame+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension InstallationOfLinedDoorFrame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstallationOfLinedDoorFrame> {
        return NSFetchRequest<InstallationOfLinedDoorFrame>(entityName: "InstallationOfLinedDoorFrame")
    }

    @NSManaged public var pieces: Int64
    @NSManaged public var fromRoom: Room?

}

extension InstallationOfLinedDoorFrame : Identifiable {

}
