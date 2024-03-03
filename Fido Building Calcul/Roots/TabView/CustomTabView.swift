//
//  CustomTabView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

struct CustomTabView: View {
    
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Binding var activeTab: CustomTabs
    let symbolSize: CGFloat = 27
    let titleSize: CGFloat = 9
    @State var isGoingBackInPath = false
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            Spacer()
            
            // MARK: - Projects
            VStack(spacing: 5) {
                
                Image(systemName: activeTab == .projects ? "pencil.and.ruler.fill" : "pencil.and.ruler")
                    .font(.system(size: symbolSize))
                    .frame(height: 28)
                
                Text("Projects")
                    .font(.system(size: titleSize))
                
            }.foregroundColor(activeTab == .projects ? .brandBlack : .brandBlack.opacity(0.9))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if activeTab == .projects && behaviourVM.projectsPath.count > 0 {
                            behaviourVM.projectsPath.removeLast()
                        }
                        activeTab = .projects
                    }
                }
                .onLongPressGesture(minimumDuration: 0.15) {
                    if activeTab == .projects {
                        behaviourVM.projectsPath.removeLast(behaviourVM.projectsPath.count)
                    }
                }
                .frame(width: 60)
            
            
            Spacer()
            
            // MARK: - Prices
            Button {
                withAnimation(.easeInOut(duration: 0.15)) { activeTab = .prices }
            } label: {
                
                VStack(spacing: 5) {
                    
                    Image(systemName: activeTab == .prices ? "list.bullet.rectangle.portrait.fill" : "list.bullet.rectangle.portrait")
                        .font(.system(size: symbolSize))
                        .frame(height: 28)
                    
                    Text("Price list")
                        .font(.system(size: 9))
                    
                }.foregroundColor(activeTab == .prices ? .brandBlack : .brandBlack.opacity(0.9))
                
            }.frame(width: 60)
            
            Spacer()
            
            // MARK: - Clients
                
            VStack(spacing: 5) {
                
                Image(systemName: activeTab == .clients ? "person.2.fill" : "person.2")
                    .font(.system(size: symbolSize))
                    .frame(height: 28)
                
                Text("Clients")
                    .font(.system(size: titleSize))
                
            }.foregroundColor(activeTab == .clients ? .brandBlack : .brandBlack.opacity(0.9))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if activeTab == .clients && behaviourVM.clientsPath.count > 0 {
                            behaviourVM.clientsPath.removeLast()
                        }
                        activeTab = .clients
                    }
                }
                .onLongPressGesture(minimumDuration: 0.15) {
                    if activeTab == .clients {
                        behaviourVM.clientsPath.removeLast(behaviourVM.clientsPath.count)
                    }
                }.frame(width: 60)
            
            Spacer()
            
            // MARK: - Settings
            Button {
                withAnimation(.easeInOut(duration: 0.15)) { activeTab = .settings }
            } label: {
                
                VStack(spacing: 5) {
                    
                    Image(systemName: activeTab == .settings ? "gearshape.fill" : "gearshape")
                        .font(.system(size: symbolSize))
                        .frame(height: 28)
                    
                    Text("Settings")
                        .font(.system(size: titleSize))
                    
                }.foregroundColor(activeTab == .settings ? .brandBlack : .brandBlack.opacity(0.9))
                
            }.frame(width: 60)
            
            Spacer()
            
        }.padding(.bottom, 10)
            .frame(maxWidth: .infinity, maxHeight: 90)
            .background {
                Color.brandWhite.opacity(0.5)
                    .background(.ultraThinMaterial)
            }
        
    }
    
}
