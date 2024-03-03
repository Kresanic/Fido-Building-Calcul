//
//  CreateUserButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ContractorBubble: View {
    
    var contractor: Contractor
    var hasChevron = true
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(contractor.name ?? "")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                if let bID = contractor.businessID {
                    Text(bID)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                }
            }
            
            Spacer()
            
            if hasChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
            }
            
        }.padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}
