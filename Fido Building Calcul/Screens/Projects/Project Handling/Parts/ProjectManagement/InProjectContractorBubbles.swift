//
//  InProjectContractorBubble.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI

struct InProjectContractorBubble: View {
    
    var contractor: Contractor
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(contractor.name ?? "Name")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                if let bID = contractor.businessID {
                    Text(bID)
                        .font(.system(size: 13, weight: .semibold))
                }
                
            }.foregroundStyle(Color.brandBlack.opacity(0.8))
            
            Spacer()
            
        }.padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}

struct InProjectNoContractorBubble: View {
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text("Assign contractor")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    
                Text("For details in the price offer")
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
        
    }
    
}

