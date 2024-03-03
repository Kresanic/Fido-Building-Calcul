//
//  PenetrationCoat+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension PenetrationCoat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PenetrationCoat> {
        return NSFetchRequest<PenetrationCoat>(entityName: "PenetrationCoat")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var fromRoom: Room?

}

extension PenetrationCoat : Identifiable {

}
