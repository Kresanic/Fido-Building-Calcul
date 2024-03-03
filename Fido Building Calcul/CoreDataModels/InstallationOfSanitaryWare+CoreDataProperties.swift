//
//  InstallationOfSanitaryWare+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension InstallationOfSanitaryWare {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstallationOfSanitaryWare> {
        return NSFetchRequest<InstallationOfSanitaryWare>(entityName: "InstallationOfSanitaryWare")
    }

    @NSManaged public var pieces: Int64
    @NSManaged public var fromRoom: Room?

}

extension InstallationOfSanitaryWare : Identifiable {

}
