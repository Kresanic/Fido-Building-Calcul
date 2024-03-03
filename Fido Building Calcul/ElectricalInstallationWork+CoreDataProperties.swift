//
//  ElectricalInstallationWork+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension ElectricalInstallationWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ElectricalInstallationWork> {
        return NSFetchRequest<ElectricalInstallationWork>(entityName: "ElectricalInstallationWork")
    }

    @NSManaged public var hours: Int64
    @NSManaged public var fromRoom: Room?

}

extension ElectricalInstallationWork : Identifiable {

}
