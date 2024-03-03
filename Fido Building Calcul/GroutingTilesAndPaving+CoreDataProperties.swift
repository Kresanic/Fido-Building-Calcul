//
//  GroutingTilesAndPaving+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension GroutingTilesAndPaving {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroutingTilesAndPaving> {
        return NSFetchRequest<GroutingTilesAndPaving>(entityName: "GroutingTilesAndPaving")
    }

    @NSManaged public var width: Int64
    @NSManaged public var length: Int64
    @NSManaged public var fromRoom: Room?

}

extension GroutingTilesAndPaving : Identifiable {

}
