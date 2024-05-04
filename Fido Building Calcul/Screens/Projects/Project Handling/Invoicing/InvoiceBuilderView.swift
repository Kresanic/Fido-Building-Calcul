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
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Text("Invoice Builder")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.brandBlack)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 20)
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
                            .font(.system(size: 21, weight: .medium))
                            .foregroundStyle(.brandBlack)
                            .frame(width: 60, height: 60, alignment: .trailing)
                    }
                    
                }
                
                Text("Items")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.brandBlack)
                    .padding(.bottom, -10)
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
                
                InvoiceBuilderSummaryView(viewModel: viewModel)
                
            }.padding(.horizontal, 15)
                .padding(.bottom, 15)
            
        }
        .scrollDismissesKeyboard(.immediately)
        .sheet(item: $viewModel.dialogWindow) { dialog in
            DialogWindow(dialog: dialog)
        }
        
    }
    
}
