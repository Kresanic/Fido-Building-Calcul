//
//  Window+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension Window {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Window> {
        return NSFetchRequest<Window>(entityName: "Window")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var inBricklayingOfLoadBearingMasonry: BricklayingOfLoadBearingMasonry?
    @NSManaged public var inBricklayingOfPartitions: BricklayingOfPartitions?
    @NSManaged public var inNettingWall: NettingWall?
    @NSManaged public var inPlasterboardCeiling: PlasterboardCeiling?
    @NSManaged public var inPlasterboardPartition: PlasterboardPartition?
    @NSManaged public var inPlasteringWall: PlasteringWall?

}

extension Window : Identifiable {

}
