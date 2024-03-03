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
    
    init(propertyCategory: PropertyCategories) {
        
        _propertyCategory = State(initialValue: propertyCategory)
        
        let projectRequest = Project.fetchRequest()
        
        projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        
        projectRequest.predicate = NSPredicate(format: "category == %@ AND isArchived == NO", propertyCategory.rawValue)
        
        _inCategoryProjects = FetchRequest(fetchRequest: projectRequest)
        
    }
    
    var body: some View {
            
            ScrollView {
                
                VStack {
                    
                    // MARK: Title and Settings Gear
                    HStack {
                        Text(PropertyCategories.readableSymbol(propertyCategory))
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                        if !viewModel.isCreatingNewProject {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { viewModel.isCreatingNewProject = true }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }
                        }
                        
                    }.padding(.bottom, 15)
                    
                    // MARK: List of all of the Projects in the Category
                    VStack {
                        
                        if inCategoryProjects.isEmpty {
                            NoProjectBubbleView(isCreatingNewProject: $viewModel.isCreatingNewProject)
                        } else {
                            ForEach(inCategoryProjects) { project in
                                ProjectBubbleView(project: project)
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
                        .presentationDetents([.height(300)])
                        .presentationCornerRadius(25)
                }
                .background(Color.brandWhite)
        }
    
}
