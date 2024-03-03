//
//  Event+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 19/01/2024.
//
//

import Foundation
import CoreData


public class HistoryEvent: NSManagedObject {

    var historyEventType: ProjectEvents {
        return ProjectEvents(rawValue: self.type ?? "created") ?? .created
    }
    
}
