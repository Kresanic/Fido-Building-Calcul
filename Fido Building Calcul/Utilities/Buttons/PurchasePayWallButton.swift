//
//  PurchasePayWallButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

struct PurchaseButton: View {
    
    var hasFreeTrail: Bool
    
    var body: some View {
        
        if hasFreeTrail {
            Text("Start Free Trial & Subscribe")
                .font(.system(size: 22, weight: .semibold))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundColor(.brandWhite)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.brandBlack)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
        } else {
            Text("Subscribe")
                .font(.system(size: 22, weight: .semibold))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundColor(.brandWhite)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.brandBlack)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
        }
        
    }
    
}
