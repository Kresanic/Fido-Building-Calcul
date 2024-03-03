//
//  NettingCeiling+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension NettingCeiling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NettingCeiling> {
        return NSFetchRequest<NettingCeiling>(entityName: "NettingCeiling")
    }

    @NSManaged public var length: Int64
    @NSManaged public var width: Int64
    @NSManaged public var fromRoom: Room?

}

extension NettingCeiling : Identifiable {

}
