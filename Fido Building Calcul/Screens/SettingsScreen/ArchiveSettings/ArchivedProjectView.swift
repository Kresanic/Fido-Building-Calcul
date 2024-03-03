//
//  ArchivedProjectView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ArchivedProjectsView: View {
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.archivedDate, ascending: false)], predicate: NSPredicate(format: "isArchived == YES")) var archivedProjects: FetchedResults<Project>
    @Environment(\.managedObjectContext) var viewcontext
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "tray.2.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Archived projects")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(archivedProjects.isEmpty ? "No archived projects" : "Archived projects" )
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                ForEach(archivedProjects) { project in
                    
                    HStack {
                        
                        Button {
                            behaviourVM.switchToProjectsPage(with: project)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text(project.unwrappedName)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                    .multilineTextAlignment(.leading)
                                
                                if archiveForDays > 90 {
                                    Text("\(project.numberOfRooms) rooms")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(Color.brandBlack)
                                        .transition(.opacity)
                                } else {
                                    Text("\(archiveForDays - daysBetween(project: project)) days till deletion")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(Color.brandBlack)
                                        .transition(.opacity)
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                        Button {
                            behaviourVM.showDialogWindow(using:
                                    .init(alertType: .approval,
                                          title: "Unarchive project \(project.unwrappedName)?",
                                          subTitle: "This project will be activated and can be found in its specified category.") {
                                    unArchiveProject(of: project)
                                    project.addToToHistoryEvent(ProjectEvents.unArchived.entityObject)
                                    }
                            )
                        } label: {
                            Image(systemName: "tray.circle.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .frame(width: 44)
                        }
                        Button {
                            behaviourVM.showDialogWindow(using:
                                    .init(alertType: .warning,
                                          title: "Delete project \(project.unwrappedName)?",
                                          subTitle: "Permanently deleting this project will result in the loss of all data. This change is irreversible.") {
                                    deleteProject(of: project)
                                    }
                            )
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .padding(.horizontal, 10)
                                .frame(width: 44)
                        }
                        
                        
                    } .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    
                }
                
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.bottom, 70)
        }
        
        
    }
    
    private func unArchiveProject(of project: Project) {
        withAnimation(.easeInOut) {
            project.isArchived = false
            project.archivedDate = nil
            try? viewcontext.save()
        }
    }
    
    private func deleteProject(of project: Project) {
        withAnimation(.easeInOut) {
            viewcontext.delete(project)
            try? viewcontext.save()
        }
    }
    
    private func daysBetween(project: Project) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: project.archivedDate ?? Date.now, to: Date.now)
        return components.day ?? 0
    }
    
}
