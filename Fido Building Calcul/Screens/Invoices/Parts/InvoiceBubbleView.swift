//
//  InvoiceBubbleView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 11/07/2024.
//

import SwiftUI

struct InvoiceBubbleView: View {
    
    @FetchRequest var fetchedInvoices: FetchedResults<Invoice>
    
    init(invoice: Invoice) {
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        let invoiceCID = invoice.cId ?? UUID()
        
        request.fetchLimit = 1
        
        request.predicate = NSPredicate(format: "cId == %@", invoiceCID as CVarArg)
        
        _fetchedInvoices = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let invoice = fetchedInvoices.first {
            
            HStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    
                    if let projectName = invoice.toProject?.name {
                        
                        HStack(spacing: 3) {
                            
                            Text(invoice.stringNumber)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                            
                            if let date = invoice.dateCreated, invoice.statusCase != .afterMaturity {
                                Text(date, format: .dateTime.day().month().year())
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                            }
                            
                            Spacer()
                        }
                        
                        Text(projectName)
                            .font(.system(size: 20, weight: .semibold))
                            .lineLimit(1)
                            .foregroundStyle(Color.brandBlack)
                            .multilineTextAlignment(.leading)
                        
                    } else {
                        Text(invoice.stringNumber)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                    }
                    
                    
                    if let clientName = invoice.toClient?.name {
                        Text(clientName)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                    }
                    
                    
                    
                }.frame(height: 50)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    
                    invoice.bubble
                    
                    Text(invoice.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 20, weight: .semibold))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color.brandBlack)
                    
                    Text("VAT not included")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.brandBlack)
                        .lineLimit(1)
                    
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
                
            }.padding(10)
                .padding(.horizontal, 5)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
        }
        
    }
    
}
