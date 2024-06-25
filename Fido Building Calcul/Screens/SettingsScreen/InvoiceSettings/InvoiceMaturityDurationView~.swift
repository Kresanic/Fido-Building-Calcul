//
//  InvoiceMaturityDurationView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/04/2024.
//

import SwiftUI

struct InvoiceMaturityDurationView: View {
    
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Maturity duration")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                VStack {
                    
                    ForEach(MaturityDuration.allCases, id: \.self) { forTime in
                        InvoiceMaturityButton(maturityTime: forTime.rawValue)
                            .transition(.scale)
                        
                    }
                    
                    InvoiceCustomMaturityButton()
                        .transition(.scale)
                    
                }
                
                Text("The set maturity for the new invoices created will be \(invoiceMaturityDuration) days from the moment of creation.")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                
            }
            
        }
    }
    
}

struct InvoiceMaturityButton: View {
    
    var maturityTime: Int
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    
    var body: some View {
        
        Button {
            withAnimation { invoiceMaturityDuration = maturityTime }
        } label: {
            
            HStack {
                
                VStack(alignment: .leading, spacing: 1) {
                    
                    Text("\(maturityTime) days")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }.multilineTextAlignment(.leading)
                
                Spacer()
                
                CheckedCircle(isSelected: invoiceMaturityDuration == maturityTime).transition(.scale.combined(with: .opacity)).scaleEffect(0.8)
                
            }.padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        
    }
    
}

struct InvoiceCustomMaturityButton: View {
    
    @State var customDuration: String = ""
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    
    var body: some View {
        
        HStack {
            
            TextField("Custom days", text: $customDuration)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .keyboardType(.numberPad)
                .submitLabel(.done)
                .lineLimit(1)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        
                        HStack {
                            Button("Cancel") {
                                dismissKeyboard()
                            }
                            
                            Spacer()
                            
                            Button("Save") {
                                if let duration = Int(customDuration), duration > 0 {
                                    if MaturityDuration.isOneOfTheCases(duration) {
                                        withAnimation {
                                            invoiceMaturityDuration = duration
                                            customDuration = ""
                                            dismissKeyboard()
                                        }
                                    } else {
                                        withAnimation { invoiceMaturityDuration = duration }
                                        dismissKeyboard()
                                    }
                                }
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                    }
                }
            
            Spacer()
            
            CheckedCircle(isSelected: invoiceMaturityDuration == Int(customDuration)).transition(.scale.combined(with: .opacity)).scaleEffect(0.8)
            
        }.padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .animation(.easeInOut, value: customDuration.isEmpty)
            .transition(.opacity)
            .task {
                if !MaturityDuration.isOneOfTheCases(invoiceMaturityDuration) {
                    withAnimation { customDuration = String(invoiceMaturityDuration) }
                }
                
            }
        
    }
    
}
