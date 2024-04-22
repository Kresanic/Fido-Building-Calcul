//
//  InvoiceSettings.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/04/2024.
//

import SwiftUI

struct InvoiceSettings: View {
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Text("Invoice")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .padding(.bottom, 15)
                
                InvoiceMaturityDurationView()
                   
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            
            
        }
        
    }
    
}
