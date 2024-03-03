//
//  NettingCeiling+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension NettingCeiling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NettingCeiling> {
        return NSFetchRequest<NettingCeiling>(entityName: "NettingCeiling")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var length: Double
    @NSManaged public var width: Double
    @NSManaged public var fromRoom: Room?

}

extension NettingCeiling : Identifiable {

}
