//
//  TitleAndNotes.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct TitleAndNotesView: View {
    
    @ObservedObject var viewModel: InProjectScreenViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    var project: Project
    var hasDismissButton: Bool?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                
                Text(project.projectNumber)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)

                ProjectStatusBubble(projectStatus: project.statusEnum, deployment: .inProject)
                    .transition(.scale.combined(with: .opacity))
                
                Spacer()
                    
            }
//            .onTapGesture {
//                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
//                    let impactMed = UIImpactFeedbackGenerator(style: .light)
//                    project.status = project.statusEnum.advanceStatus
//                    let historyEventObject = behaviourVM.historyEventObjectFromProjectStatus(project.status)
//                    project.addToToHistoryEvent(historyEventObject)
//                    try? viewContext.save()
//                    impactMed.impactOccurred()
//                }
//            }
                
            HStack {
                
                TextField("Project name", text: $viewModel.projectName)
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .submitLabel(.done)
                    .onSubmit { viewModel.saveProjectName(project: project) }
                
                if hasDismissButton ?? false {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.brandBlack)
                    }
                }
                
            }
            
            InputNotes(project: project, viewModel: viewModel)
        }
    }
    
}

struct InputNotes: View {
    
    var project: Project
    @ObservedObject var viewModel: InProjectScreenViewModel
    
    var body: some View {
        
        TextField("Notes", text: $viewModel.projectNotes, axis: .vertical)
            .font(.system(size: 17))
            .multilineTextAlignment(.leading)
            .lineLimit(1...4)
            .onChange(of: viewModel.projectNotes, perform: { newValue in
                viewModel.saveProjectNotes(project: project)
            })
            .frame(maxWidth: .infinity)
        
    }
    
}
