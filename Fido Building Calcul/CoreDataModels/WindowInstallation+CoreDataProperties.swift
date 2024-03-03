//
//  WindowInstallation+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension WindowInstallation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindowInstallation> {
        return NSFetchRequest<WindowInstallation>(entityName: "WindowInstallation")
    }

    @NSManaged public var pieces: Int64
    @NSManaged public var fromRoom: Room?

}

extension WindowInstallation : Identifiable {

}
