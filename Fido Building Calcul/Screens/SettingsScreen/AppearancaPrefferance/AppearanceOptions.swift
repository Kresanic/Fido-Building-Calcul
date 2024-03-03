//
//  AppearanceOptions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 10/01/2024.
//

import SwiftUI

struct AppearanceOptions: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    var body: some View {
        
        VStack {
            
            Button {
                behaviours.setAppearance(to: .none)
            } label: {
                AppearanceBubble(title: "Automatic", subTitle: "Appearance of the app will match the appearance of the entire iPhone.", isActive: behaviours.prefferesAppearance == 0)
            }
            
            Button {
                behaviours.setAppearance(to: .light)
            } label: {
                AppearanceBubble(title: "Light", subTitle: "Appearance of the app will override the appearance of the entire iPhone and will be set to Light.", isActive: behaviours.prefferesAppearance == 1)
            }
            
            Button {
                behaviours.setAppearance(to: .dark)
            } label: {
                AppearanceBubble(title: "Dark", subTitle: "Appearance of the app will override the appearance of the entire iPhone and will be set to Dark.", isActive: behaviours.prefferesAppearance == 2)
            }
            
        }
        
    }
    
}


fileprivate struct AppearanceBubble: View {
    
    var title: LocalizedStringKey
    var subTitle: LocalizedStringKey
    var isActive: Bool
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 1) {
                
                Text(title)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                 
                Text(subTitle)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                
            }.multilineTextAlignment(.leading)
            
            Spacer()
            
            CheckedCircle(isSelected: isActive).transition(.scale.combined(with: .opacity))
            
        }.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}
