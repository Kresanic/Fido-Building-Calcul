//
//  InvoiceBuilderSummaryView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceBuilderSummaryView: View {
    
    @ObservedObject var viewModel: InvoiceBuilderViewModel
    @Environment(\.managedObjectContext) var viewContext
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("Summary")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.brandBlack)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text("without VAT")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Text(viewModel.invoiceDetails.unPriceWithoutVAT, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .contentTransition(.numericText())
                    
                }
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text("VAT")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Text(viewModel.invoiceDetails.unCumulativeVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .contentTransition(.numericText())
                    
                }
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text("Total price")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    
                    Spacer(minLength: 20)
                    
                    Text(viewModel.invoiceDetails.totalPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .minimumScaleFactor(0.4)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }
                
                Button {
                    generateInvoiceObject()
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
//                        .opacity(0.8)
                }
                
            }.padding(15)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 25, style: .continuous))
                
        }
        
    }
    
    private func generateInvoiceObject() {
        
        let missingValues = viewModel.invoiceDetails.missingValues
        
        if missingValues.isEmpty {
            
            let invoice = Invoice(context: viewContext)
            
            invoice.cId = UUID()
            invoice.dateCreated = Date.now
            invoice.number = Int64(viewModel.invoiceDetails.invoiceNumber) ?? 0
            
            invoice.pdfFile = try? Data(contentsOf: viewModel.invoiceDetails.pdfURL)
            
            invoice.toClient = viewModel.invoiceDetails.client
            invoice.toContractor = viewModel.invoiceDetails.contractor
            invoice.toProject = viewModel.project
            
            invoice.maturityDays = Int64(invoiceMaturityDuration)
            invoice.priceWithoutVat = viewModel.invoiceDetails.unPriceWithoutVAT
            invoice.vatAmount = viewModel.invoiceDetails.unCumulativeVat
            
            invoice.status = InvoiceStatus.unpaid.rawValue
            
            try? viewContext.save()
            
            viewModel.isShowingPDF = true
            
        } else {
            viewModel.missingValues = missingValues
            viewModel.isShowingMissingValues = true
        }
        
    }
    
}

