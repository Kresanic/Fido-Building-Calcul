//
//  PavingCeramic+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension PavingCeramic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PavingCeramic> {
        return NSFetchRequest<PavingCeramic>(entityName: "PavingCeramic")
    }

    @NSManaged public var width: Int64
    @NSManaged public var length: Int64
    @NSManaged public var fromRoom: Room?

}

extension PavingCeramic : Identifiable {

}
