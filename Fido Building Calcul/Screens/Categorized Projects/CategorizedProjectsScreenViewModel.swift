//
//  CategorizedProjectsScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI
import CoreData

@MainActor final class CategorizedProjectsScreenViewModel: ObservableObject {
    
    @Published var isCreatingNewProject = false
    @Published var projectName = ""
    @Published var isShowingDetailedProject: Bool = false
    @Published var selectedProject: Project? = nil {
        didSet {
            isShowingDetailedProject = selectedProject != nil ? true : false
        }
    }
    
    
    
    func createNewProject(propertyCategory: PropertyCategories) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let newProject = Project(context: viewContext)
        
        guard projectName != "" else { return }
        
        newProject.name = projectName
        newProject.dateCreated = Date.now
        newProject.category = propertyCategory.rawValue
        newProject.cId = UUID()
        
        try? viewContext.save()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isCreatingNewProject = false
            projectName = ""
        }
        
    }
    
}
