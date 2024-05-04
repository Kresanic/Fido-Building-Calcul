//
//  InvoiceDetailView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//

import SwiftUI
import PDFKit

struct InvoiceDetailView: View {
    
    var invoice: Invoice
    @State var dialog: Dialog?
    @State var isShowingPreview = false
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment:. center) {
                
                Text(invoice.stringNumber)
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundStyle(.brandBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(invoice.toClient?.unwrappedName ?? "")
                
                Text(invoice.toProject?.unwrappedName ?? "")
                
                Text(invoice.toContractor?.name ?? "")
                
                Button {
                    isShowingPreview = true
                } label: {
                    HStack {
                        
                        Text("Preview invoice")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.brandBlack)
                        
                    }.padding(15)
                        .padding(.vertical, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                        }
                }
                
                Button {
                    dialog = .init(alertType: .warning, title: "Delete invoice?", subTitle: "By continuing, invoice will be permanently deleted and will not be able to retrieve any data. The number of the invoice will be freed and there will be no record of creating this invoice.", action: {
                        deleteCurrentInvoice()
                    })
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.brandWhite)
                        
                        Text("Delete")
                            .font(.system(size: 21, weight: .medium))
                            .foregroundStyle(.brandWhite)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(.brandBlack)
                    .clipShape(.capsule)
                    .padding(.horizontal, 50)
                }
                
                
            }.frame(maxWidth: .infinity)
            
        }.scrollIndicators(.hidden)
            .sheet(item: $dialog) { dialog in
                DialogWindow(dialog: dialog)
            }
            .sheet(isPresented: $isShowingPreview) {
                if let data = invoice.pdfFile {
                    InvoicePDFDocumentPreviewSheet(pdfDoc: PDFDocument(data: data))
                }
            }
        
    }
    
    private func deleteCurrentInvoice() {
        viewContext.delete(invoice)
        try? viewContext.save()
        dismiss()
    }
    
}

