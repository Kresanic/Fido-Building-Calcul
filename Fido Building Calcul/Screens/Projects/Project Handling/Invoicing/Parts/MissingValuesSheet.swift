//
//  MissingValuesSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/05/2024.
//

import SwiftUI

struct InvoiceMissingValuesSheet: View {
    
    var missingValues: [IdentifiableInvoiceMissingValue]
    @ObservedObject var viewModel: InvoiceBuilderViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    @State var isShowingPDF = false
    @State var isGeneratingPDF = false
    
    init(_ missingValues: [IdentifiableInvoiceMissingValue], viewModel: InvoiceBuilderViewModel) {
        self.missingValues = missingValues
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Missing values")
                .font(.system(size: 33, weight: .bold))
                .foregroundStyle(.brandBlack)
                .padding(.top, 15)
            
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        let generic = missingValues.filter { $0.value is InvoiceValues }
                        if !generic.isEmpty {
                            MissingValueCategory(title: "Generic values", values: generic)
                        }
                        
                        let contractors = missingValues.filter { $0.value is ContractorValues }
                        if !contractors.isEmpty {
                            MissingValueCategory(title: "Contractor values", values: contractors)
                        }
                        
                        let clients = missingValues.filter { $0.value is ClientValues }
                        if !clients.isEmpty {
                            MissingValueCategory(title: "Client values", values: clients)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 80)
                    
                }
                .scrollIndicators(.hidden)
                Spacer()
            }.frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottom) {
                VStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("I will fill in!")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.brandWhite)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 10)
                            .background(.brandBlack)
                            .clipShape(.capsule)
                    }
                    .padding(.top, 5)
                    
                    Button {
                        Task { await generateInvoiceObject() }
                    } label: {
                        Text("Generate anyways")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.brandBlack)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(.brandGray)
                            .clipShape(.capsule)
                    }
                    
                }.frame(maxWidth: .infinity)
                    .background { Color.brandWhiteBackground.blur(radius: 5).background(.brandWhiteBackground) }
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
        .background(.brandWhiteBackground)
        .sheet(isPresented: $isShowingPDF) {
            InvoicePreviewSheet(project: viewModel.project, pdfURL: viewModel.invoiceDetails.pdfURL, cashReceiptURL: viewModel.invoiceDetails.cashReceiptURL)
                .presentationCornerRadius(30)
                .onDisappear { dismiss() }
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
                    isShowingPDF = true
                    viewModel.wasPDFShown = true
                }
                withAnimation { isGeneratingPDF = false }
            }
        }
    }
    
}

struct MissingValueCategory: View {
    
    var title: LocalizedStringKey
    var values: [IdentifiableInvoiceMissingValue]?
    
    var body: some View {
        
        if let values {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(.brandBlack)
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(values) { val in
                        HStack(spacing: 4) {
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 3))
                                .foregroundStyle(.brandBlack)
                            
                            Text(val.value.title)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.brandBlack)
                            
                        }.padding(.leading, 7)
                    }
                }
            }.padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.brandGray)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
        }
    }
    
}
