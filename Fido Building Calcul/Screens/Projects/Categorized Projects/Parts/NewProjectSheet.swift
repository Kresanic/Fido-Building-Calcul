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
    @EnvironmentObject var behaviours: BehavioursViewModel
    @FocusState private var isFocused: Bool
    @State var isChoosingContractor = false
    @State var chosenContractor: Contractor?
    
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
                            behaviours.redraw()
                            behaviours.switchToProjectsPage(with: newProject)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .task { isFocused = true }
                
            }.padding(.top, 10)
            
            if behaviours.activeContractor == nil {
                
                Spacer()
                
                VStack(spacing: 0) {
                    
                    Text("Contractor")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.bottom, 5)
                    
                    Button {
                        isChoosingContractor = true
                    } label: {
                        if let chosenContractor {
                            ContractorBubble(contractor: chosenContractor, hasChevron: true)
                        } else {
                            InProjectNoContractorBubble().padding(.horizontal, 15)
                        }
                    }
                    
                }
                
            }
            
            Spacer()
            
            let permissionToCreate = (behaviours.activeContractor != nil || chosenContractor != nil) && !nameOfProject.isEmpty
            
            Button {
                if let newProject = createNewProject() {
                    dismiss()
                    behaviours.redraw()
                    behaviours.switchToProjectsPage(with: newProject)
                }
            } label: {
                
                Text("Create project")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(permissionToCreate ? Color.brandBlack : Color.brandBlack.opacity(0.6))
                    .clipShape(.rect(cornerRadius: 25, style: .continuous))
                
            }.padding(.bottom, 10)
                .disabled(!permissionToCreate)
            
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
        .background(Color.brandWhite)
        .sheet(isPresented: $isChoosingContractor) {
            ChoosingContractorView(contractor: $chosenContractor)
                .presentationDetents([.large])
                .presentationCornerRadius(25)
                .onDisappear{ behaviours.redraw() }
        }
        .task {
            print(behaviours.activeContractor, chosenContractor)
        }
    }
    
    private func createNewProject() -> Project? {
        
        guard !nameOfProject.isEmpty else { return nil }
        guard chosenContractor != nil else { return nil }
        
        behaviours.activeContractor = chosenContractor
        
        return withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            
            let newProjectNumber = behaviours.newProjectNumber()
            guard newProjectNumber != 0 else { return nil }
            
            let newProject = Project(context: viewContext)
            
            newProject.cId = UUID()
            newProject.category = toCategory.rawValue
            newProject.name = nameOfProject
            newProject.dateCreated = Date.now
            newProject.isArchived = false
            newProject.status = 0
            newProject.number = newProjectNumber
            newProject.toContractor = chosenContractor
            
            behaviours.addEvent(.created, to: newProject)
            
            guard let _ = behaviours.generalPriceListObject(toProject: newProject) else { return nil }
            
            try? viewContext.save()
            
            return newProject
            
        }
        
    }
    
}
