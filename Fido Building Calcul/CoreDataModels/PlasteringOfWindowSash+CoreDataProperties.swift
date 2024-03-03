//
//  PlasteringOfWindowSash+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension PlasteringOfWindowSash {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlasteringOfWindowSash> {
        return NSFetchRequest<PlasteringOfWindowSash>(entityName: "PlasteringOfWindowSash")
    }

    @NSManaged public var basicMeter: Double
    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var fromRoom: Room?

}

extension PlasteringOfWindowSash : Identifiable {

}
