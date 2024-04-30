//
//  InvoiceItemPriceInput.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceItemPriceInput: View {
    
    var title: String
    @Binding var value: String
    var editingChanged: () -> Void
    @Environment(\.locale) var locale
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Spacer()
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("0", text: $value, onEditingChanged: { _ in
                editingChanged()
            })
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.brandBlack)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .frame(width: 100, height: 37)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(maxWidth: 125, alignment: .trailing)
            
            Text(locale.currencySymbol ?? "$")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
        }        
        
    }
    
}
