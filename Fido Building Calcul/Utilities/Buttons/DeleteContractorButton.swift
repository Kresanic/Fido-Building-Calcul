//
//  DeleteContractorButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI

struct DeleteContractorButton: View {
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Spacer()
            
            Text("Delete contractor")
                .font(.system(size: 20, weight: .medium))
            
            Image(systemName: "trash")
                .font(.system(size: 18, weight: .regular))
            
            Spacer()
            
        }
        .foregroundStyle(Color.brandBlack)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.brandGray)
        .clipShape(Capsule())
        
        
    }
    
}

