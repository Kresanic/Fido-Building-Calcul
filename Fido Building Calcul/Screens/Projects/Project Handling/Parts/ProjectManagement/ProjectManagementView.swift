//
//  ProjectManagementView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/01/2024.
//

import SwiftUI

struct ProjectManagementView: View {
    
    var project: Project
    @State var isChoosingContractor = false
    @State var chosenContractor: Contractor?
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "archivebox.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Project management")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            InProjectPriceList(project: project)
            
            if let contractor = project.contractor {
                InProjectContractorBubble(contractor: contractor)
            } else {
                Button {
                    isChoosingContractor = true
                } label: {
                    InProjectNoContractorBubble()
                        .padding(.bottom, 3)
                }
            }
            
            if project.isArchived {
                ProjectIsArchivedBubble(project: project)
                HStack(spacing: 8) {
                    DuplicateButton(project: project)
                    DeleteProjectButtonNarrow(project: project)
                }   
            } else {
                HStack(spacing: 8) {
                    DuplicateButton(project: project)
                    ArchiveButtonNarrow(project: project)
                }
            }
            
            ProjectHistory(of: project)
            
        }
        .sheet(isPresented: $isChoosingContractor) {
            ChoosingContractorView(contractor: $chosenContractor)
                .presentationDetents([.large])
                .presentationCornerRadius(25)
                .onDisappear{
                    project.toContractor = chosenContractor
                    try? viewContext.save()
                    behaviours.redraw()
                }
        }
        
    }
    
}

fileprivate struct DuplicateButton: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behaviours: BehavioursViewModel
    @StateObject var viewModel = DuplicateProjectViewModel()
    var project: Project
    
    var body: some View {
        
        Button {
            if let _ = viewModel.copyProject(of: project) {
                project.addToToHistoryEvent(ProjectEvents.duplicated.entityObject)
                behaviours.dropProjectFromPath()
            }
        } label: {
            ProjectManagementButton(type: .duplicate)
        }
        
    }
    
}

fileprivate struct ArchiveButtonNarrow: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var behaviours: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    var project: Project
    
    var body: some View {
        
        Button {
            behaviours.showDialogWindow(using: .init(alertType: .approval, title: "Archive project \(project.unwrappedName)?", subTitle: "Archiving this project will not result in data loss. You can find this project in the 'Archive' tab in the app settings.", action: {
                archiveProject(project: project)
                project.addToToHistoryEvent(ProjectEvents.archived.entityObject)
                dismiss()
            }))
        } label: {
            ProjectManagementButton(type: .archive)
        }
        
    }
    
    func archiveProject(project: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        project.isArchived = true
        project.archivedDate = Date.now
        
        try? viewContext.save()
        
    }
    
}

fileprivate struct DeleteProjectButtonNarrow: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var behaviours: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    var project: Project
    
    var body: some View {
        
        Button {
            behaviours.showDialogWindow(using:
                    .init(alertType: .warning,
                          title: "Delete project \(project.unwrappedName)?",
                          subTitle: "Permanently deleting this project will result in the loss of all data. This change is irreversible.") {
                    deleteProject(of: project)
                dismiss()
                    }
            )
        } label: {
            ProjectManagementButton(type: .delete)
        }
        
    }
    
    private func deleteProject(of project: Project) {
        withAnimation(.easeInOut) {
            viewContext.delete(project)
            try? viewContext.save()
        }
    }
    
}


fileprivate struct InProjectPriceList: View {
    
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @EnvironmentObject var behaviours: BehavioursViewModel
    var project: Project
    @State var selectedPriceList: PriceList?
    
    init(project: Project) {
        
        self.project = project
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let priceList = fetchedPriceList.last {
            
            Button { selectedPriceList = priceList } label: {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        Text("Project price list")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text("last change: ")
                            .font(.system(size: 13, weight: .semibold))
                        +
                        Text(priceList.dateEdited ?? Date.now, format: .dateTime.day().month().year())
                            .font(.system(size: 13, weight: .semibold))
                        
                    }.foregroundStyle(Color.brandBlack.opacity(0.8))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.brandBlack)
                    
                }.padding(.vertical, 15)
                    .padding(.horizontal, 15)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
            }.sheet(item: $selectedPriceList) { priceList in
                InProjectPricesListView(priceList: priceList)
                    .presentationDetents([.large])
                    .presentationCornerRadius(25)
                    .onDisappear { behaviours.redraw() }
            }
        }

    }
    
    private func localizedDate(from date: Date?) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        if let date {
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            let formattedDate = dateFormatter.string(from: Date.now)
            return formattedDate
        }
        
    }
}
