//
//  NewProjectSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct NewProjectSheet: View {
    
    var toCategory: PropertyCategories
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
                    .onSubmit {
                        if let newProject = createNewProject() {
                            dismiss()
                            behaviourVM.redraw()
                            behaviourVM.switchToProjectsPage(with: newProject)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .task { isFocused = true }
                
            }.padding(.top, 10)
            
            Spacer()
            
            Button {
                if let newProject = createNewProject() {
                    dismiss()
                    behaviourVM.redraw()
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
        
    }
    
    private func createNewProject() -> Project? {
        
        guard !nameOfProject.isEmpty else { return nil }
        
        return withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            
            let newProjectNumber = behaviourVM.newProjectNumber()
            
            let newProject = Project(context: viewContext)
            
            newProject.cId = UUID()
            newProject.category = toCategory.rawValue
            newProject.name = nameOfProject
            newProject.dateCreated = Date.now
            newProject.isArchived = false
            newProject.status = 0
            newProject.number = newProjectNumber
            
            behaviourVM.addEvent(.created, to: newProject)
            
            guard let _ = behaviourVM.generalPriceListObject(toProject: newProject) else { return nil }
            
            try? viewContext.save()
            
            return newProject
            
        }
        
    }
    
}
