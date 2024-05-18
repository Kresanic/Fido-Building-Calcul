//
//  InvoiceBuilderView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/04/2024.
//

import SwiftUI

struct InvoiceBuilderView: View {
    
    var project: Project
    @StateObject var viewModel: InvoiceBuilderViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isNoteFocused: Bool

    @AppStorage("invoiceNote") var invoiceNote: String = ""
    
    init(project: Project) {
        self.project = project
        self._viewModel = StateObject(wrappedValue: InvoiceBuilderViewModel(project))
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                HStack(alignment: .lastTextBaseline) {
                    
                    Text("Invoice Builder")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.brandBlack)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button {
                        if viewModel.madeChanges {
                            viewModel.dialogWindow = .init(alertType: .approval, title: "Delete changes?", subTitle: "By exiting this view all changes made will be deleted.", action: {
                                dismiss()
                            })
                        } else { dismiss() }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.brandBlack)
                            .frame(width: 60, height: 40, alignment: .bottom)
                    }
                    
                }
                
                InvoiceBuilderSummaryView(viewModel: viewModel)
                
                Text("Settings")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.brandBlack)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        
                        Text("Date of dispatch")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.brandBlack)
                        
                        Spacer()
                        
                        DatePicker("", selection: $viewModel.invoiceDetails.dateOfDispatch, displayedComponents: .date)
                        
                    }.padding(.horizontal, 10)
                        .frame(height: 55)
                        .background(.brandGray)
                        .clipShape(.rect(cornerRadius: 17, style: .continuous))
                    
                    HStack {
                        
                        Text("Payment type")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.brandBlack)
                        
                        Spacer()
                        
                        Picker("Payment type", selection: $viewModel.invoiceDetails.paymentType) {
                            Text("Cash").tag(PaymentType.cash)
                            Text("Bank transfer").tag(PaymentType.bankTransfer)
                        }.pickerStyle(.segmented)
                        
                    }.padding(.horizontal, 10)
                        .frame(height: 55)
                        .background(.brandGray)
                        .clipShape(.rect(cornerRadius: 17, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        Text("Note")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.brandBlack)
                        
                        TextField("In the case of non-payment of the invoice will automatically claim over to a collections company MAHUT Group.", text: $viewModel.invoiceDetails.note, axis: .vertical)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.brandBlack)
                            .lineLimit(1...5)
                            .focused($isNoteFocused)
                            .submitLabel(.return)
                            .padding(10)
                            .background(.brandWhite.opacity(0.3))
                            .background {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .strokeBorder(Color.brandBlack, lineWidth: 2)
                            }
                            .task {
                                withAnimation {
                                    viewModel.invoiceDetails.note = invoiceNote
                                }
                            }
                            
                    }.padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(.brandGray)
                        .clipShape(.rect(cornerRadius: 17, style: .continuous))
                    
                }
                
                
                Text("Items")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.brandBlack)
                    .padding(.bottom, -10)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    let works = viewModel.invoiceDetails.workItems
                    
                    if !works.isEmpty {
                        Text("Work")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.top, 15)
                            .padding(.bottom, 3)
                        
                        VStack(spacing: 8) {
                            ForEach(works) { item in
                                
                                InvoiceBuilderItemBubble(viewModel: viewModel, item: item)
                                
                            }
                        }
                    }
                    
                    let materials = viewModel.invoiceDetails.materialItems
                    if !materials.isEmpty {
                        
                        Text("Material")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.top, 15)
                            .padding(.bottom, 3)
                        
                        VStack(spacing: 8) {
                            ForEach(materials) { item in
                                
                                InvoiceBuilderItemBubble(viewModel: viewModel, item: item)
                                
                            }
                        }
                    }
                    
                    let others = viewModel.invoiceDetails.otherItems
                    if !others.isEmpty {
                        Text("Other")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.top, 15)
                            .padding(.bottom, 3)
                        
                        VStack(spacing: 8) {
                            ForEach(others) { item in
                                
                                InvoiceBuilderItemBubble(viewModel: viewModel, item: item)
                                
                            }
                        }
                    }
                    
                }
                
            }.padding(.horizontal, 15)
                .padding(.bottom, 15)
            
        }
        .scrollDismissesKeyboard(.immediately)
        .background{ Color.brandWhite.onTapGesture{ dismissKeyboard() } }
        .sheet(item: $viewModel.dialogWindow) { dialog in
            DialogWindow(dialog: dialog)
        }
        .sheet(isPresented: $viewModel.isShowingPDF) {
            InvoicePreviewSheet(project: viewModel.project, pdfURL: viewModel.invoiceDetails.pdfURL).onDisappear { dismiss() }
        }
        .sheet(isPresented: $viewModel.isShowingMissingValues) {
            if let missingValues = viewModel.missingValues {
                InvoiceMissingValuesSheet(missingValues, viewModel: viewModel)
                    .presentationCornerRadius(25)
                    .presentationDetents([.fraction(0.65)])
                    .onDisappear { dismiss() }
            }
        }
        
    }
    
}
