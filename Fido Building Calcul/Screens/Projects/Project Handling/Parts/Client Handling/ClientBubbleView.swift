//
//  ClientBubbleView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ContactBubbleView: View {
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "person.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Client")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            HStack {
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    Text("John Doe")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Text("Down Street 3, London")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                    
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
                
            }.padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        
    }
    
}
