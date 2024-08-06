//
//  InvoiceItemPriceInput.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceItemPriceInput: View {
    
    var title: LocalizedStringKey
    @Binding var value: String
    var editingChanged: () -> Void
    @Environment(\.locale) var locale
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Spacer()
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("0", text: $value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .focused($isFocused)
                .frame(width: 100, height: 37)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .frame(maxWidth: 125, alignment: .trailing)
            
            Text(locale.currencySymbol ?? "$")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
        }
        .onChange(of: isFocused) { value in
            if !isFocused { editingChanged() }
        }
        
    }
    
}
