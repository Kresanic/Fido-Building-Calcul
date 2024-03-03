//
//  SettingsScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI

struct SettingsScreen: View {
    
    @StateObject var viewModel = SettingsScreenViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    ScreenTitle(title: "Nastavenia")
                    
                    ArchiveDurationView(viewModel: viewModel)
                    
                    ArchivedProjectsView(viewModel: viewModel)
                    
                    ContactBubblesView().padding(.top, 15)
                    
                    Text("Fido Building Calcul")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandBlack)
                        .padding(.top, 15)
                    
                    Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(.brandBlack.opacity(0.7))
                        .padding(.bottom, 5)
                    
                    Text("©Fido, s.r.o. Všetky práva vyhradené.")
                        .font(.system(size: 12))
                        .foregroundColor(.brandBlack.opacity(0.5))
                        .multilineTextAlignment(.center)
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                
            }.scrollIndicators(.hidden)
                .navigationBarHidden(true)
                .onTapGesture { dismissKeyboard() }
            
        }
        
    }
    
}

enum ArchiveForTime: Int, CaseIterable {
    case twoWeeks = 14
    case month = 30
    case twoMonths = 60
    case forever = 99999
}

struct ArchiveDurationView: View {
    
    @ObservedObject var viewModel: SettingsScreenViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "tray.2.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Archív")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Archivovať po dobu")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .padding(.leading, 15)
                
                    HStack {
                     Spacer()
                        ForEach(ArchiveForTime.allCases, id: \.self) { forTime in
                            ArchiveTimeBubble(viewModel: viewModel, timeToArchive: forTime)
                                .transition(.scale)
                            Spacer()
                        }
                    }
                
            }.padding(.vertical, 12)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
}

struct ArchiveTimeBubble: View {
    
    @ObservedObject var viewModel: SettingsScreenViewModel
    var timeToArchive: ArchiveForTime
    
    var body: some View {
        
        let title = timeToArchive.rawValue >= 99999 ? "Navždy" : "\(timeToArchive.rawValue) dní"
        
        Button {
            withAnimation { viewModel.archiveForDays = timeToArchive.rawValue }
        } label: {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(viewModel.archiveForDays == timeToArchive.rawValue ? Color.brandWhite : Color.brandBlack)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(viewModel.archiveForDays == timeToArchive.rawValue ? Color.brandBlack : Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

struct ArchivedProjectsView: View {
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.archivedDate, ascending: false)], predicate: NSPredicate(format: "isArchived == YES")) var archivedProjects: FetchedResults<Project>
    @Environment(\.managedObjectContext) var viewcontext
    @ObservedObject var viewModel: SettingsScreenViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            let titlePrefix = archivedProjects.isEmpty ? "Žiadne a" : "A"
            
            Text("\(titlePrefix)rchivovavané projekty")
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
                            
                            if viewModel.archiveForDays > 90 {
                                Text(project.numberOfRooms == 1 ? "\(project.numberOfRooms) miestnosť" : "\(project.numberOfRooms) miestnost\(project.numberOfRooms < 0 ? "i" : "i")")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                    .transition(.opacity)
                            } else {
                                Text("\(viewModel.archiveForDays - viewModel.daysBetween(project: project)) dní do vymazania")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                    .transition(.opacity)
                            }
                            
                        }
                        
                        Spacer()
                        
                    }
                    
                    Button {
                        unArchiveProject(of: project)
                    } label: {
                        Image(systemName: "tray.circle.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: 44)
                    }
                    
                    Button {
                        deleteProject(of: project)
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
        
    }
    
    private func unArchiveProject(of project: Project) {
        withAnimation(.easeInOut) {
            project.isArchived = false
            try? viewcontext.save()
        }
    }
    
    private func deleteProject(of project: Project) {
        withAnimation(.easeInOut) {
            viewcontext.delete(project)
            try? viewcontext.save()
        }
    }
    
}

struct ContactBubblesView: View {
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5){
            
                HStack(alignment: .center) {
                    
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.brandBlack)
                    
                    Text("Ostatné")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.brandBlack)
                    
                    Spacer()
                    
                }
                
            VStack(spacing: 8) {
                
                Button {
                    if let url = URL(string: "mailto:fidopo@gmail.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("Kontakt")
                        .styleOfBubblesInSettings()
                }
                
                Button {
                    UIApplication.shared.open(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") ?? URL(string: "https://tenu.app/privacypolicy")!)
                } label: {
                    Text("Podmienky používania")
                        .styleOfBubblesInSettings()
                }
                
                Button {
                    print("privacy policy")
                    UIApplication.shared.open(URL(string: "https://www.fido.sk")!)
                } label: {
                    Text("Zásady ochrany osobných údajov")
                        .styleOfBubblesInSettings()
                }
                
            }
        }
    }
}
