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
    
    @State var propertyCategory: PropertyCategories
    
    init(propertyCategory: PropertyCategories) {
        
        _propertyCategory = State(initialValue: propertyCategory)
        
        let projectRequest = Project.fetchRequest()
        
        projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        
        projectRequest.predicate = NSPredicate(format: "category == %@ AND isArchived == NO", propertyCategory.rawValue)
        
        _inCategoryProjects = FetchRequest(fetchRequest: projectRequest)
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    // MARK: Title and Settings Gear
                    HStack {
                        Text(slovakTranslation(propertycategory: propertyCategory))
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) { viewModel.isCreatingNewProject = true }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.brandBlack)
                        }
                        
                    }.padding(.bottom, 15)
                    
                    // MARK: List of all of the Projects in the Category
                    VStack {
                        
                        if viewModel.isCreatingNewProject {
                            NewProjectView(viewModel: viewModel, propertyCategory: propertyCategory)
                                .transition(.scale(scale: 0.0, anchor: .topTrailing))
                        }
                        
                        ForEach(inCategoryProjects) { project in
                            Button {
                                viewModel.selectedProject = project
                            } label: {
                                ProjectBubbleView(project: project)
                            }
                        }
                        
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
//                    .padding(.top, 100)
                
            }.scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.automatic)
                //.navigationBarHidden(true)
                //.ignoresSafeArea(edges: .top)
                .navigationTitle(slovakTranslation(propertycategory: propertyCategory))
                .navigationBarHidden(true)
                
            
        }.fullScreenCover(isPresented: $viewModel.isShowingDetailedProject) {
            if let unwrappedProject = viewModel.selectedProject {
                InProjectScreen(project: unwrappedProject)
            }
        }
        
    }
    
}

struct NewProjectView: View {
    
    @ObservedObject var viewModel: CategorizedProjectsScreenViewModel
    var propertyCategory: PropertyCategories
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Nový Projekt")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.brandBlack)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isCreatingNewProject = false
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.brandBlack)
                            .padding(.all, 9)
                            .background(Color.brandWhite)
                            .clipShape(Circle())
                            .padding(.trailing, 20)
                    }
                }
            
            TextField("", text: $viewModel.projectName)
                .labelsHidden()
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.brandBlack)
                .placeholder(when: viewModel.projectName.isEmpty, placeholder: {
                    Text("Názov Projektu")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.brandBlack.opacity(0.7))
                })
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 40)
                .submitLabel(.done)
                .onSubmit { viewModel.createNewProject(propertyCategory: propertyCategory) }
            
            
            
            Button {
                viewModel.createNewProject(propertyCategory: propertyCategory)
                dismissKeyboard()
            } label: {
                Text("Vytvoriť!")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            }
            
        }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        
    }
    
}

struct ProjectBubbleView: View {
    
    var project: Project
    
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline) {
            
            VStack(alignment: .leading) {
                
                Text(project.unwrappedName)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.brandBlack)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                
                Text(project.numberOfRooms == 1 ? "\(project.numberOfRooms) miestnosť" : "\(project.numberOfRooms) miestnost\(project.numberOfRooms < 0 ? "i" : "i")")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            
            Spacer()
            
//            VStack(alignment: .trailing) {
//                
//                Text("Odhadovaná cena:")
//                    .font(.system(size: 10, weight: .medium))
//                    .foregroundStyle(Color.brandBlack)
//                
//                Text("83 423,34 €")
//                    .font(.system(size: 25, weight: .semibold))
//                    .foregroundStyle(Color.brandBlack)
//                    .lineLimit(1)
//                    .multilineTextAlignment(.trailing)
//                
//            }
            
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(Color.brandGray)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        
        
    }
    
}

