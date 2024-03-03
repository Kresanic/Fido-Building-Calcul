//
//  PaintingWall+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension PaintingWall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaintingWall> {
        return NSFetchRequest<PaintingWall>(entityName: "PaintingWall")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var fromRoom: Room?

}

extension PaintingWall : Identifiable {

}
