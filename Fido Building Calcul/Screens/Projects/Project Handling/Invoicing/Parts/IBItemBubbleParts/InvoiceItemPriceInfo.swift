//
//  InvoiceItemPriceInfo.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceItemPriceInfo: View {
    
    var title: LocalizedStringKey
    var value: Double
    var big: Bool = false
    @Environment(\.locale) var locale
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            
            Text(title)
                .font(.system(size: big ? 23 : 17, weight: big ? .semibold : .medium))
                .foregroundStyle(Color.brandBlack)
            
            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: big ? 23 : 17, weight: big ? .semibold : .medium))
                .foregroundStyle(Color.brandBlack)
                .contentTransition(.numericText())
                .frame(maxWidth: 150, alignment: .trailing)
                
            
        }
        
    }
    
}
