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
    @Published var isShowingDetailedProject: Bool = false
    @Published var isDeleting = false
    @Published var selectedProject: Project? = nil {
        didSet {
            isShowingDetailedProject = selectedProject != nil ? true : false
        }
    }
    
}
