//
//  PayWallFeature.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/10/2023.
//

import SwiftUI

struct PayWallFeature: View {
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            Text("Pro Unlocks")
                .font(.system(size: 35, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
            
            IncludedInProfessionalRow(title: "change general prices", subTitle: "feature allows users to modify prices in the general price list, affecting all future projects")
            
            IncludedInProfessionalRow(title: "adjust individual project prices", subTitle: "feature enables users to modify prices in a project's price list, influencing prices exclusively within the selected project")
            
            IncludedInProfessionalRow(title: "export to PDF", subTitle: "feature enables the export of entire projects into PDF format, allowing direct sharing with clients")
            
        }
        .padding(.vertical, 23)
        .background(Color.brandWhite)
            .clipShape(.rect(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 15)
        
    }
    
}

fileprivate struct IncludedInProfessionalRow: View {
    
    var title: LocalizedStringKey
    var subTitle: LocalizedStringKey
    
    var body: some View {
        
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 17))
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(subTitle)
                    .font(.system(size: 13, weight: .medium))
                    
            }
            
            Spacer()
            
        }.foregroundStyle(Color.brandBlack)
            .padding(.horizontal, 15)
        
    }
    
}
