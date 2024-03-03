//
//  PickClientButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct PickClientButton: View {
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text("No client")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                Text("Associate project with a client")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 24))
                .foregroundStyle(Color.brandBlack)
            
        }.padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                    .background(Color.brandGray)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
            }
        
    }
    
}
