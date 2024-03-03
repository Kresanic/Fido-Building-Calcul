//
//  TileCeramic+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension TileCeramic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TileCeramic> {
        return NSFetchRequest<TileCeramic>(entityName: "TileCeramic")
    }

    @NSManaged public var length: Int64
    @NSManaged public var width: Int64
    @NSManaged public var fromRoom: Room?

}

extension TileCeramic : Identifiable {

}
