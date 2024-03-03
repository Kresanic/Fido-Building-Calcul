//
//  DemolitionWork+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension DemolitionWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DemolitionWork> {
        return NSFetchRequest<DemolitionWork>(entityName: "DemolitionWork")
    }

    @NSManaged public var hours: Int64
    @NSManaged public var fromRoom: Room?

}

extension DemolitionWork : Identifiable {

}
