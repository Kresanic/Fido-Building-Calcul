//
//  ProjectHandling.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct ProjectStatusBubble: View {
    
    var projectStatus: ProjectStatus
    var deployment: ProjectStatusBubbleDeployment
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 3) {
            
            Image(systemName: projectStatus.sfSymbol)
                
            Text(projectStatus.label)
            
        }.font(deployment.textFont)
            .foregroundStyle(Color.brandWhite)
            .padding(.horizontal, deployment.padding.0)
            .padding(.vertical, deployment.padding.1)
            .background(projectStatus.backgroundColor)
            .clipShape(.capsule(style: .continuous))
            .transition(.scale.combined(with: .opacity))
            .padding(.vertical, 5)
            .padding(deployment == .inProject ? .trailing : .leading, 15)
        
    }
    
}

struct NoProjectBubbleView: View {
    
    @Binding var isCreatingNewProject: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Spacer()
            
            Image(systemName: "pencil.and.ruler.fill")
                .font(.system(size: 80, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
            Text("Add project")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
            
            Text("Create project in which you can calculate prices and material for individual work")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isCreatingNewProject = true }
            } label: {
                Text("Create")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding(.top, 25)
            }
            
            Spacer()
        
        }.padding(.vertical, 25)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .padding(.horizontal, 15)
        
    }
    
}
