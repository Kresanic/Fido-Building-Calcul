//
//  CreateContractorButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI

struct CreateContractorButton: View {
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text("Create profile")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                
                Text("Fill out information for price offers")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                
            }
            
            Spacer()
            
            Image(systemName: "plus")
                .font(.system(size: 24))
                .foregroundStyle(Color.brandBlack)
            
        }.padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}
