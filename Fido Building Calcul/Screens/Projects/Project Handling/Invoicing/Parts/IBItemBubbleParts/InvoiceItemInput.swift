//
//  InvoiceItemInput.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceItemInput: View {
    
    var title: LocalizedStringKey
    @Binding var value: String
    var unit: UnitsOfMeasurement
    @Environment(\.locale) var locale
    var isPriceOriented: Bool
    
    // MARK: init for unit inputs
    public init(title: LocalizedStringKey, value: Binding<String>, unit: UnitsOfMeasurement) {
        self.title = title
        self._value = value
        self.unit = unit
        self.isPriceOriented = false
    }
    
    // MARK: init for price inputs
    public init(title: LocalizedStringKey, value: Binding<String>) {
        self.title = title
        self._value = value
        self.unit = .basicMeter
        self.isPriceOriented = true
    }
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            
            VStack(alignment: .center, spacing: 4) {
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .frame(width: 120)
                
                TextField("0", text: $value)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: 100, height: 37)
                    .background(Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
            }
            
            if isPriceOriented {
                Text(locale.currencySymbol ?? "$")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
            } else {
                Text(UnitsOfMeasurement.readableSymbol(unit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            
        }
        
    }
    
}
