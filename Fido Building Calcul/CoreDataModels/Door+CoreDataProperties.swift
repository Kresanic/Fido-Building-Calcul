//
//  Door+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension Door {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Door> {
        return NSFetchRequest<Door>(entityName: "Door")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var inBricklayingOfLoadBearingMasonry: BricklayingOfLoadBearingMasonry?
    @NSManaged public var inBricklayingOfPartitions: BricklayingOfPartitions?
    @NSManaged public var inNettingWall: NettingWall?
    @NSManaged public var inPlasterboardPartition: PlasterboardPartition?
    @NSManaged public var inPlasteringWall: PlasteringWall?

}

extension Door : Identifiable {

}
