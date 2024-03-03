//
//  ProjectIsArchivedbutton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ProjectIsArchivedBubble: View {
    
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    var project: Project
    
    var body: some View {
        
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Archived")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                if archiveForDays <= 90 {
                    Text("\(archiveForDays - daysBetween(project: project)) days till deletion")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .transition(.opacity)
                }
                
            }
            
            Spacer()
            
            Button {
                behaviourVM.showDialogWindow(using: .init(alertType: .approval,
                                                          title: "Unarchive project \(project.unwrappedName)?",
                                                          subTitle: "This project will be activated and can be found in its specified category.") {
                    withAnimation(.easeInOut) {
                        project.isArchived = false
                        project.archivedDate = nil
                        project.addToToHistoryEvent(ProjectEvents.unArchived.entityObject)
                        try? viewContext.save()
                        dismiss()
                    }
                })
            } label: {
                Image(systemName: "tray.and.arrow.up.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .padding(.horizontal, 10)
            }
        } .padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        
    }
    
    private func daysBetween(project: Project) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: project.archivedDate ?? Date.now, to: Date.now)
        return components.day ?? 0
    }
    
}
