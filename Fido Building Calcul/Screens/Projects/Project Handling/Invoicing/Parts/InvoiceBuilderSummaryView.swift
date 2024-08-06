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
    @State var isGeneratingPDF = false
    
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
                    Task { await generateInvoiceObject() }
                } label: {
                    HStack(spacing: 5) {
                        
                        if isGeneratingPDF {
                            ProgressView()
                        } else {
                            Text("Generate Invoice")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                            
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                        }
                        
                    }.padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandBlack)
                        .clipShape(.rect(cornerRadius: 30, style: .continuous))
                }
                
            }.padding(15)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 25, style: .continuous))
                
        }
        
    }
    
    private func performInvoiceGeneration() async -> Bool {
        isGeneratingPDF = true // Toggle on when process begins
        defer {
            isGeneratingPDF = false // Ensure it toggles off when the process ends
        }

        return await withCheckedContinuation { continuation in
            Task {
                let invoice = Invoice(context: viewContext)
                invoice.cId = UUID()
                invoice.dateCreated = Date.now.startOfTheDay
                invoice.number = Int64(viewModel.invoiceDetails.invoiceNumber) ?? 0

                do {
                    invoice.pdfFile = try Data(contentsOf: viewModel.invoiceDetails.pdfURL)
                } catch {
                    print("Failed to load PDF data: \(error)")
                    continuation.resume(returning: false)
                    return
                }

                if let receiptURL = viewModel.invoiceDetails.cashReceiptURL {
                    do {
                        invoice.cashReceipt = try Data(contentsOf: receiptURL)
                    } catch {
                        print("Failed to load cash receipt data: \(error)")
                        continuation.resume(returning: false)
                        return
                    }
                }

                invoice.toClient = viewModel.invoiceDetails.client
                invoice.toContractor = viewModel.invoiceDetails.contractor
                invoice.toProject = viewModel.project
                invoice.maturityDays = Int64(invoiceMaturityDuration)
                invoice.priceWithoutVat = viewModel.invoiceDetails.unPriceWithoutVAT
                invoice.vatAmount = viewModel.invoiceDetails.unCumulativeVat
                invoice.status = InvoiceStatus.unpaid.rawValue

                viewModel.project.addToToHistoryEvent(ProjectEvents.invoiceGenerated.entityObject)

                do {
                    try viewContext.save()
                } catch {
                    print("Failed to save context: \(error)")
                    continuation.resume(returning: false)
                    return
                }

                continuation.resume(returning: true)
            }
        }
    }

    private func generateInvoiceObject() async {
        let missingValues = viewModel.invoiceDetails.missingValues
        await MainActor.run { withAnimation { isGeneratingPDF = true } }
        if missingValues.isEmpty {
            let success = await Task.detached(priority: .background) {
                return await performInvoiceGeneration()
            }.value
            
            await MainActor.run {
                if success {
                    viewModel.isShowingPDF = true
                    viewModel.wasPDFShown = true
                }
                withAnimation { isGeneratingPDF = false }
            }
        } else {
            await MainActor.run {
                viewModel.missingValues = missingValues
                viewModel.isShowingMissingValues = true
                withAnimation { isGeneratingPDF = false }
            }
        }
    }
    
}

