//
//  EditClientButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct EditClientButton: View {
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Spacer()
            
            Text("Edit client")
                .font(.system(size: 20, weight: .medium))
            
            Image(systemName: "scissors")
                .font(.system(size: 18, weight: .regular))
            
            Spacer()
            
        }
        .foregroundStyle(Color.brandWhite)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.brandBlack)
        .clipShape(Capsule())
        
        
    }
    
}
