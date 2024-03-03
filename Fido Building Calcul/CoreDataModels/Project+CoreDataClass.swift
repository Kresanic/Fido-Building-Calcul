//
//  Project+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//


import CoreData
import SwiftUI

@objc(Project)
public class Project: NSManagedObject {
    
    public var projectNumber: String {
        
        let year = Calendar.current.component(.year, from: dateCreated ?? Date.now)
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        
        let numberAsString = formatter.string(from: number as NSNumber)
        
        return "\(year)\(numberAsString ?? "999")"
    }
    
    public var unwrappedName: String {
        name ?? "Bez Mena"
    }
    
    public var unwrappedNotes: String {
        notes ?? ""
    }
    
    public var client: Client? {
        return toClient
    }
    
    public var contractor: Contractor? {
        toContractor
    }
    
    public var numberOfRooms: Int {
    
        let set = consistsOfRooms as? Set<Room> ?? []
    
        return set.count
    
    }
    
    var statusEnum: ProjectStatus {
        return ProjectStatus(rawValue: Int(status)) ?? .notSent
    }
    
    public var associatedRooms: [Room] {
    
        let set = consistsOfRooms as? Set<Room> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now < $1.dateCreated ?? Date.now
        }
    }
    
    public var associatedClientName: String? { toClient?.name }
    
}
