//
//  HorizontalInvoiceFilter.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 11/07/2024.
//

import SwiftUI

struct HorizontalInvoiceFilterView: View {
    
    @Binding var selectedInvoiceStatus: InvoiceStatus?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                
                Button {
                    selectedInvoiceStatus = nil
                } label: {
                    Text("All")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(selectedInvoiceStatus == nil ? Color.brandWhite : Color.brandBlack)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                        .background {
                            Capsule()
                                .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                .background(selectedInvoiceStatus == nil ? Color.brandBlack : Color.brandWhite)
                                .clipShape(.capsule)
                        }
                }
                
                ForEach(InvoiceStatus.allCases, id: \.self) { status in
                    
                    Button {
                        selectedInvoiceStatus = status
                    } label: {
                        Text(status.name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(selectedInvoiceStatus == status ? Color.brandWhite : Color.brandBlack)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 10)
                            .background {
                                Capsule()
                                    .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                    .background(selectedInvoiceStatus == status ? Color.brandBlack : Color.brandWhite)
                                    .clipShape(.capsule)
                            }
                    }
                    
                }
                
                Spacer()
                
            }.padding(.horizontal, 15)
            
        }
        .padding(.bottom, 5)
        .scrollIndicators(.hidden)
    }
    
}
