//
//  InProjectScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/07/2023.
//

import SwiftUI
import CoreData
import PDFKit

struct InProjectScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = InProjectScreenViewModel()
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest var fetchedProjects: FetchedResults<Project>
    var hasDismissButton: Bool?
    
    init(project: Project, hasDismissButton: Bool?) {
        
        self.hasDismissButton = hasDismissButton
        
        let request = Project.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        
        let projectCId = project.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "cId == %@", projectCId as CVarArg)
        
        _fetchedProjects = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let project = fetchedProjects.first {
            
            ScrollView {
                
                ScrollViewReader { scrollPos in
                    
                    VStack(spacing: 20) {
                        
                        TitleAndNotesView(viewModel: viewModel, project: project, hasDismissButton: hasDismissButton)
                        
                        ClientHandlingView(viewModel: viewModel, project: project)
                        
                        TotalPriceOffer(project: project)
                        
                        RoomsList(project: project, viewModel: viewModel, scrollToPos: scrollPos).id("RoomCreation")
                        
                        ProjectManagementView(project: project)
                        
                    }.padding(.horizontal, 15)
                        .padding(.bottom, 105)
                        .onAppear { viewModel.projectLoading(project: project) }
                        .toolbar(.hidden, for: .bottomBar)
                        .sheet(isPresented: $viewModel.isPickingClient) {
                            InProjectChoosingClientView(project: project)
                                .presentationDetents([.large])
                                .presentationCornerRadius(25)
                        }
                        
                    
                }
                
            }.scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
            .background {
                Color.brandWhite
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            viewModel.saveEntireProject(project: project)
                            viewModel.tappedArchiveButton = false
                            viewModel.isDeletingRooms = false
                            dismissKeyboard()
                        }
                    }
                    .ignoresSafeArea()
            }
            
        }
    }
    
}
