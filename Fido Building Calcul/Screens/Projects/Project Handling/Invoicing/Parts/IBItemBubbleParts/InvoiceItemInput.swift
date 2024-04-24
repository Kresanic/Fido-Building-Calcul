//
//  InvoiceItemInput.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceItemInput: View {
    
    var title: String
    @Binding var value: String
    var unit: UnitsOfMeasurement
    var editingChanged: () -> Void
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            
            VStack(alignment: .center, spacing: 4) {
                
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
                
            }
            
            Text(UnitsOfMeasurement.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }
        
    }
    
}
