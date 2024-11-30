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
    
    init(project: Project) {
        self.project = project
        self._viewModel = StateObject(wrappedValue: InvoiceBuilderViewModel(project))
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                ScrollViewReader { scrollProxy in
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
                        
                        InvoiceBuilderSettingsView(viewModel: viewModel)
                        
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
                                        
                                        InvoiceBuilderItemBubble(viewModel: viewModel, item: item, isItemFocused: $viewModel.isFocusedOnItem, scrollProxy).id(item.id)
                                        
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
                                        
                                        InvoiceBuilderItemBubble(viewModel: viewModel, item: item, isItemFocused: $viewModel.isFocusedOnItem, scrollProxy).id(item.id)
                                        
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
                                        
                                        InvoiceBuilderItemBubble(viewModel: viewModel, item: item, isItemFocused: $viewModel.isFocusedOnItem, scrollProxy).id(item.id)
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    }.padding(.horizontal, 15)
                    
                }
                
            }
            .scrollDismissesKeyboard(.immediately)
            .background{ Color.brandWhite.onTapGesture{ dismissKeyboard() }.ignoresSafeArea() }
            .sheet(item: $viewModel.dialogWindow) { dialog in
                DialogWindow(dialog: dialog)
            }
            .sheet(isPresented: $viewModel.isShowingPDF) {
                InvoicePreviewSheet(project: viewModel.project, pdfURL: viewModel.invoiceDetails.pdfURL, cashReceiptURL: viewModel.invoiceDetails.cashReceiptURL)
                    .presentationCornerRadius(30)
                    .onDisappear { dismiss() }
            }
            .sheet(isPresented: $viewModel.isShowingMissingValues) {
                if let missingValues = viewModel.missingValues {
                    InvoiceMissingValuesSheet(missingValues, viewModel: viewModel)
                        .presentationCornerRadius(25)
                        .presentationDetents([.fraction(0.65)])
                        .onDisappear { if viewModel.wasPDFShown { dismiss() } }
                }
            }
        }
    }
    
}
