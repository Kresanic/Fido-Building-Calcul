//
//  InvoiceBuilderSummaryView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceBuilderSummaryView: View {
    
    @ObservedObject var viewModel: InvoiceBuilderViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("Summary")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.brandBlack)
                .padding(.top, 15)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                
                let priceWithoutVAT = viewModel.invoiceItems.reduce(0.0) {
                    if $1.active {
                        return $0 + $1.price
                    }
                    
                    return $0
                }
                
                let cumulativeVAT = viewModel.invoiceItems.reduce(0.0) {
                    if $1.active {
                        return $0 + ($1.price * ($1.vat/100))
                    }
                    
                    return $0
                }
                
                let totalPrice = priceWithoutVAT + cumulativeVAT
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text("without VAT")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Text(round(priceWithoutVAT/100)*100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text("VAT")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                    
                    Text(round(cumulativeVAT/100)*100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text("Total price")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    
                    Spacer(minLength: 20)
                    
                    
                    Text(totalPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }
                
                Button {
                    
                } label: {
                    HStack(spacing: 5) {
                        
                        Text("Generate Invocie")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandWhite)
                        
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.brandWhite)
                        
                    }.padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandBlack)
                        .clipShape(.rect(cornerRadius: 30, style: .continuous))
                        .opacity(0.8)
                }
                
            }.padding(15)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 25, style: .continuous))
        }
    }
}

