//
//  PlasteringOfReveal+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension PlasteringOfReveal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlasteringOfReveal> {
        return NSFetchRequest<PlasteringOfReveal>(entityName: "PlasteringOfReveal")
    }

    @NSManaged public var basicMeter: Int64
    @NSManaged public var fromRoom: Room?

}

extension PlasteringOfReveal : Identifiable {

}
