//
//  PlumbingWork+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/07/2023.
//
//

import Foundation
import CoreData


extension PlumbingWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlumbingWork> {
        return NSFetchRequest<PlumbingWork>(entityName: "PlumbingWork")
    }

    @NSManaged public var pieces: Int64
    @NSManaged public var fromRoom: Room?

}

extension PlumbingWork : Identifiable {

}
