//
//  ProjectsScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI
import CoreData

@MainActor final class PropertyCategoryBubbleViewModel: ObservableObject {
    
    func countProjectsInCategory(in propertyCategory: PropertyCategories) -> Int {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let projectFetchRequest = Project.fetchRequest()
        
        projectFetchRequest.predicate = NSPredicate(format: "category == %@ AND isArchived == NO", propertyCategory.rawValue)
        
        if let projectsCount = try? viewContext.count(for: projectFetchRequest) {
            return projectsCount
        } else {
            return 0
        }
        
    }
    
}
