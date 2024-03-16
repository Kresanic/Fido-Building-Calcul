//
//  CategorziedProjectsScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

struct CategorziedProjectsScreen: View {
    
    @StateObject var viewModel = CategorizedProjectsScreenViewModel()
    @FetchRequest var inCategoryProjects: FetchedResults<Project>
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @State var propertyCategory: PropertyCategories
    @Environment(\.managedObjectContext) var viewContext
    
    init(propertyCategory: PropertyCategories, activeContractor: Contractor?) {
        
        _propertyCategory = State(initialValue: propertyCategory)
        
        let projectFetchRequest = Project.fetchRequest()
        
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.number, ascending: false)]
        
        let category = propertyCategory.rawValue as CVarArg
        
        if let activeContractor = activeContractor {
            projectFetchRequest.predicate = NSPredicate(format: "(category == %@ AND  toContractor == %@ AND isArchived == NO) OR toContractor == nil", [category, activeContractor])
        } else {
            projectFetchRequest.predicate = NSPredicate(format: "category == %@ AND isArchived == NO", category)
        }
        
      _inCategoryProjects = FetchRequest(fetchRequest: projectFetchRequest)
        
    }
    
    var body: some View {
            
            ScrollView {
                
                VStack(spacing: 15) {
                    
                    // MARK: Title and Settings Gear
                    HStack {
                        Text(PropertyCategories.readableSymbol(propertyCategory))
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                        if !inCategoryProjects.isEmpty {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { viewModel.isDeleting.toggle() }
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }
                        }
                        
                        if !viewModel.isCreatingNewProject {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                    viewModel.isCreatingNewProject = true
                                    viewModel.isDeleting = false
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }
                        }
                        
                    }.padding(.bottom, 15)
                    
                    // MARK: List of all of the Projects in the Category
                    LazyVStack {
                        
                        if inCategoryProjects.isEmpty {
                            NoProjectBubbleView(isCreatingNewProject: $viewModel.isCreatingNewProject)
                        } else {
                            ForEach(inCategoryProjects) { project in
                                ProjectBubbleView(project: project, isDeleting: viewModel.isDeleting)
                                    .modifier(ProjectBubbleViewDeletion(isDeleting: $viewModel.isDeleting, atButtonPress: {
                                        withAnimation(.easeInOut) {
                                            viewContext.delete(project)
                                            try? viewContext.save()
                                        }
                                    }))
                            }
                            
                        }
                        
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                
            }.scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.automatic)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $viewModel.isCreatingNewProject) {
                    NewProjectSheet(toCategory: propertyCategory)
                        .presentationDetents(
                            behavioursVM.activeContractor == nil ? [.medium] : [.height(300)]
                            )
                        .presentationCornerRadius(25)
                }
                .background(Color.brandWhite)
        }
    
}
