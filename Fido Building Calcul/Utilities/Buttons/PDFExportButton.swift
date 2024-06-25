//
//  PDFExportButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 16/01/2024.
//

import SwiftUI

struct PDFExportButton: View {
    
    var title: LocalizedStringKey
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.brandWhite)
            
            Image(systemName: "paperplane.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.brandBlue)
            
        }.padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(Color.brandBlack)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
        
    }
    
}

struct PDFExportButtonSmall: View {
    
    var title: LocalizedStringKey
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.brandWhite)
            
            Image(systemName: "paperplane.fill")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.brandBlue)
            
        }.padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.brandBlack)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
        
    }
    
}
