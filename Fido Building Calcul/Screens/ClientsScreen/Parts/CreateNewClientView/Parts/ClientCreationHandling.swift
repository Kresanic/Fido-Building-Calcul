//
//  ClientCreationHandling.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct NewClientsProjectSheet: View {
    
    var toClient: Client?
    var toCategory: PropertyCategories?
    @State var category: PropertyCategories? = nil
    @State var nameOfProject = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button("Cancel") {
                    dismiss()
                }.frame(width: 75, alignment: .leading)
                
                Spacer()
                
                Text("New project")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                Spacer()
                
                Button("Create") {
                    
                }.frame(width: 75, alignment: .trailing)
                
                
            }.padding(.top, 25)
                .padding(.horizontal, 10)
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("Name")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("Project name", text: $nameOfProject)
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .submitLabel(.done)
                    .focused($isFocused)
                    .multilineTextAlignment(.center)
                    .keyboardType(.default)
                    .frame(maxWidth: .infinity)
                    .task { isFocused = true }
                
            }.padding(.top, 10)
            
            
            Spacer()
            
            if toCategory == nil {
                VStack(spacing: 5) {
                    
                    Text("Project category")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                    
                    ProjectCategorySelector(category: $category)
                    
                }
            }
            
            Spacer()
            
            Button {
                if let newProject = createNewProject() {
                    dismiss()
                    behaviourVM.switchToProjectsPage(with: newProject)
                }
            } label: {
                
                Text("Create project")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.brandBlack.opacity(0.8))
                    .clipShape(.rect(cornerRadius: 25, style: .continuous))
                
            }.padding(.bottom, 10)
            
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
        .background(Color.brandWhite)
        .onAppear { if let updateCategory = toCategory { category = updateCategory } }
         
    }
    
    private func createNewProject() -> Project? {
        
        guard let category = category else { return nil }
        guard !nameOfProject.isEmpty else { return nil }
        
        let newProjectNumber = behaviourVM.newProjectNumber()
        
        let newProject = Project(context: viewContext)
        
        newProject.cId = UUID()
        newProject.category = category.rawValue
        newProject.name = nameOfProject
        newProject.dateCreated = Date.now
        newProject.isArchived = false
        newProject.toClient = toClient
        newProject.status = 0
        newProject.number = newProjectNumber
        
        guard let _ = behaviourVM.generalPriceListObject(toProject: newProject) else { return nil }
        
        try? viewContext.save()
        
        return newProject
        
    }
    
}


struct ProjectCategorySelector: View {
    
    @Binding var category: PropertyCategories?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack(spacing: 20) {
                
                ProjectCategorySelectorBubble(title: "Flat", category: .flats, changeCategory: $category)
                
                ProjectCategorySelectorBubble(title: "House", category: .houses, changeCategory: $category)
                
            }
            
            HStack(spacing: 20) {
                
                ProjectCategorySelectorBubble(title: "Company", category: .firms, changeCategory: $category)
                
                ProjectCategorySelectorBubble(title: "Cottage", category: .cottages, changeCategory: $category)
            }
            
        }.padding(.vertical, 10)
        
    }
    
}

struct ProjectCategorySelectorBubble: View {
    
    var title: LocalizedStringKey
    var category: PropertyCategories
    @Binding var changeCategory: PropertyCategories?
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { changeCategory = category }
        } label: {
            Text(title)
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(changeCategory == category ?  Color.brandWhite : Color.brandBlack)
                .frame(width: 125, height: 40)
                .background(changeCategory == category ?  Color.brandBlack : Color.brandGray)
                .clipShape(.rect(cornerRadius: 15, style: .continuous))
        }
    }
    
}
