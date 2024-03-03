//
//  PDFPreviewButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 16/01/2024.
//

import SwiftUI

struct PDFPreviewButtonSmall: View {
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Text("Preview")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Image(systemName: "eye.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
        }.padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                    .background(Color.brandWhite)
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
            }
        
    }
    
}
