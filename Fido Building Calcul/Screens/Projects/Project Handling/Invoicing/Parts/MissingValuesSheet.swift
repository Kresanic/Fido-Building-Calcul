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
                    
                    Button {
                        generateInvoiceObject()
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
            InvoicePreviewSheet(project: viewModel.project, pdfURL: viewModel.invoiceDetails.pdfURL).onDisappear { dismiss() }
        }
        
    }
    
    private func generateInvoiceObject() {
        
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
        
        isShowingPDF = true
        
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
            }
        }
    }
    
}
