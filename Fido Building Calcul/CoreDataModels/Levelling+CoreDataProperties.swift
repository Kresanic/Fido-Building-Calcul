//
//  Levelling+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension Levelling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Levelling> {
        return NSFetchRequest<Levelling>(entityName: "Levelling")
    }

    @NSManaged public var length: Int64
    @NSManaged public var width: Int64
    @NSManaged public var fromRoom: Room?

}

extension Levelling : Identifiable {

}
