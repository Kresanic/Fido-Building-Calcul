//
//  ProjectsScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

struct ProjectsScreen: View {
    
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    var body: some View {
        
        NavigationStack(path: $behavioursVM.projectsPath) {
            
            ScrollView {
                
                VStack {
                    
                    ProjectScreenTitle()
                    
                    VStack(spacing: 25) {
                        
                        ForEach(PropertyCategories.allCases) { propertyCategory in
                            Button { behavioursVM.projectsPath.append(propertyCategory) } label: {
                                PropertyCategoryBubbleView(propertyCategory: propertyCategory, activeContractor: behavioursVM.activeContractor)
                            }
                            
                        }
                        
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                
            }.scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: PropertyCategories.self) { category in
                    CategorziedProjectsScreen(propertyCategory: category, activeContractor: behavioursVM.activeContractor)
                }
                .navigationDestination(for: Project.self) { project in
                    InProjectScreen(project: project, hasDismissButton: false)
                }
                .navigationDestination(for: Room.self) { room in
                    RoomScreen(room: room)
                }
                .navigationDestination(for: Client.self) { client in
                    ClientPreviewScreen(client: client)
                }
                .navigationDestination(for: Invoice.self) { invoice in
                    InvoiceDetailView(invoice: invoice)
                }
                
        }.navigationViewStyle(.stack)
        
    }
    
}


fileprivate struct ProjectScreenTitle: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    @State var selectedDetent: PresentationDetent = .large
    @State var isChoosingContractor = false
    @State var isCreatingContractor = false
    @State var shownContractors: [Contractor] = []
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                
                if let contractorName = behaviours.activeContractor?.name {
                    Button {
                        withAnimation(.bouncy) {
                            if isChoosingContractor {
                                isChoosingContractor = false
                            } else {
                                fetchContractors()
                                isChoosingContractor = true
                            }
                        }
                    } label: {
                        HStack {
                            
                            Text(contractorName)
                                .font(.system(size: 35, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                                .padding(.vertical, 15)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 27, weight: .medium))
                                .foregroundColor(Color.brandBlack)
                                .padding(.vertical, 15)
                            
                            Spacer()
                        }
                    }
                } else {
                    Button {
                        withAnimation(.bouncy) {
                            if isChoosingContractor {
                                isChoosingContractor = false
                            } else {
                                fetchContractors()
                                isChoosingContractor = true
                            }
                        }
                    } label: {
                        HStack {
                            
                        Text("Choose contractor")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                            .padding(.vertical, 15)
                            
                        Image(systemName: "chevron.down")
                            .font(.system(size: 27, weight: .medium))
                            .foregroundColor(Color.brandBlack)
                            .padding(.vertical, 15)
                        
                        Spacer()
                    }
                    }
                }
                
            }
            
            if isChoosingContractor {
                
                VStack(spacing: 8) {
                    
                    ForEach(shownContractors) { contractor in
                    
                        Button {
                            withAnimation(.bouncy) {
                                behaviours.activeContractor = contractor
                                isChoosingContractor = false
                            }
                        } label: {
                               ContractorBubble(contractor: contractor, hasChevron: false)
                        }
                        
                    }
                    
                    Button { isCreatingContractor = true } label: {
                        CreateContractorButton()
                    }
                    
                }.padding(.bottom, 15)
                
            }
            
        }
        .sheet(isPresented: $isCreatingContractor, content: {
            ContractorEditView(presentationDetents: $selectedDetent)
                .presentationCornerRadius(25)
                .presentationDetents([.height(225), .large], selection: $selectedDetent)
                .interactiveDismissDisabled(true)
                .presentationBackground(.brandWhite)
                .onDisappear { selectedDetent = .large; fetchContractors() }
        })
        
    }
    
    func fetchContractors() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Contractor.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: false)]
        
        let fetchedContractors = try? viewContext.fetch(request)
        
        if let fetchedContractors {
            withAnimation {
                shownContractors = fetchedContractors
            }
        }
        
    }
    
    
}
