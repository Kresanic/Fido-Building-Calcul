//
//  InstallationOfCornerStrip+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension InstallationOfCornerStrip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstallationOfCornerStrip> {
        return NSFetchRequest<InstallationOfCornerStrip>(entityName: "InstallationOfCornerStrip")
    }

    @NSManaged public var basicMeter: Int64
    @NSManaged public var fromRoom: Room?

}

extension InstallationOfCornerStrip : Identifiable {

}
