//
//  NSManagedObject Extension.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/01/2024.
//

import CoreData

extension NSManagedObject {

    func copyEntireObjectGraph(context: NSManagedObjectContext) -> NSManagedObject {
    
        var cache = Dictionary<NSManagedObjectID, NSManagedObject>()
        return cloneObject(context: context, cache: &cache)
    
    }

    func cloneObject(context: NSManagedObjectContext, cache alreadyCopied: inout Dictionary<NSManagedObjectID, NSManagedObject>) -> NSManagedObject {
    
        guard let entityName = self.entity.name else {
            fatalError("source.entity.name == nil")
        }
    
        if let storedCopy = alreadyCopied[self.objectID] {
            return storedCopy
        }
        
        let cloned = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        alreadyCopied[self.objectID] = cloned
        
        if let _ = cloned.entity.attributesByName["cId"] {
            cloned.setValue(UUID(), forKey: "cId")
        }
        
        if let _ = cloned.entity.attributesByName["dateCreated"] {
            cloned.setValue(Date.now, forKey: "dateCreated")
        }
        
        if let attributes = NSEntityDescription.entity(forEntityName: entityName, in: context)?.attributesByName {
            for key in attributes.keys {
                if key != "cId" && key != "dateCreated" {
                    cloned.setValue(self.value(forKey: key), forKey: key)
                }
            }
        }

        if let relationships = NSEntityDescription.entity(forEntityName: entityName, in: context)?.relationshipsByName {
    
            for (key, value) in relationships {
                
                if key != "toHistoryEvent" {
                    
                    if value.isToMany {
                        
                        if let sourceSet = self.value(forKey: key) as? NSMutableOrderedSet {
                            
                            guard let clonedSet = cloned.value(forKey: key) as? NSMutableOrderedSet else {
                                fatalError("Could not cast relationship \(key) to an NSMutableOrderedSet")
                            }
                            
                            let enumerator = sourceSet.objectEnumerator()
                            
                            var nextObject = enumerator.nextObject() as? NSManagedObject
                            
                            while let relatedObject = nextObject {
                                
                                let clonedRelatedObject = relatedObject.cloneObject(context: context, cache: &alreadyCopied)
                                clonedSet.add(clonedRelatedObject)
                                nextObject = enumerator.nextObject() as? NSManagedObject
                                
                            }
                            
                        } else if let sourceSet = self.value(forKey: key) as? NSMutableSet {
                            
                            guard let clonedSet = cloned.value(forKey: key) as? NSMutableSet else {
                                fatalError("Could not cast relationship \(key) to an NSMutableSet")
                            }
                            
                            let enumerator = sourceSet.objectEnumerator()
                            
                            var nextObject = enumerator.nextObject() as? NSManagedObject
                            
                            while let relatedObject = nextObject {
                                
                                let clonedRelatedObject = relatedObject.cloneObject(context: context, cache: &alreadyCopied)
                                clonedSet.add(clonedRelatedObject)
                                nextObject = enumerator.nextObject() as? NSManagedObject
                                
                            }
                            
                        }
                        
                    } else {
                        
                        if let relatedObject = self.value(forKey: key) as? NSManagedObject {
                            
                            let clonedRelatedObject = relatedObject.cloneObject(context: context, cache: &alreadyCopied)
                            cloned.setValue(clonedRelatedObject, forKey: key)
                            
                        }
                        
                    }
                    
                }
            
            }
        
        }

        return cloned
    
    }
    
}
