//
//  Client+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/08/2023.
//
//


import CoreData
import SwiftUI

@objc(Client)
public class Client: NSManagedObject {
    
    public var unwrappedName: String {
        name ?? "No name"
    }
    
    public var unwrappedStreet: String {
        street ?? ""
    }
    
    public var unwrappedSecondRowStreet: String {
        secondRowStreet ?? ""
    }
    
    public var unwrappedCity: String {
        city ?? ""
    }
    
    public var unwrappedCountry: String {
        country ?? ""
    }
    
    public var associatedProjects: [Project] {
        
        let set = hasProject as? Set<Project> ?? []
    
        return Array(set)
    }
    
}
