//
//  UIParts.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct ScreenTitle: View {
    
    let title: LocalizedStringKey
    
    var body: some View {
    
        HStack {
            Text(title)
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(Color.brandBlack)
                .padding(.vertical, 15)
            
            Spacer()
            
        }
        
    }
    
}

struct ScreenTitleWithSwitch: View {
    
    let title: String
    @Binding var toSwitch: Bool
    let sfSymbol: String
    var showSwitch: Bool
    
    var body: some View {
    
        HStack {
            
            Text(title)
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(Color.brandBlack)
                .padding(.vertical, 15)
            
            Spacer()
            
            if showSwitch {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { toSwitch = true }
                } label: {
                    Image(systemName: sfSymbol)
                        .font(.system(size: 30))
                        .foregroundColor(.brandBlack)
                }
            }
            
        }
        
    }
    
}
