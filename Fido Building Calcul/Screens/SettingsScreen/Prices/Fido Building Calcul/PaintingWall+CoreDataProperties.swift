//
//  PaintingWall+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension PaintingWall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaintingWall> {
        return NSFetchRequest<PaintingWall>(entityName: "PaintingWall")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var height: Double
    @NSManaged public var width: Double
    @NSManaged public var fromRoom: Room?

}

extension PaintingWall : Identifiable {

}
