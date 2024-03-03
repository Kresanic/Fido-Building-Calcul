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
                    
                    ScreenTitle(title: "Projects")
                    
                    VStack(spacing: 25) {
                        
                        ForEach(PropertyCategories.allCases) { propertyCategory in
                            
                            NavigationLink(value: propertyCategory) {
                                PropertyCategoryBubbleView(propertyCategory: propertyCategory)
                            }
                            
                        }
                        
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                
            }.scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: PropertyCategories.self) { category in
                    CategorziedProjectsScreen(propertyCategory: category)
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
                
        }
        
    }
    
}
