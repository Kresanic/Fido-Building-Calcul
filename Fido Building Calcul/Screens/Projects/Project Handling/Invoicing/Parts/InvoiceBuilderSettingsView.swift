//
//  InvoiceBuilderSettingsView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/06/2024.
//

import SwiftUI

struct InvoiceBuilderSettingsView: View {
    
    @ObservedObject var viewModel: InvoiceBuilderViewModel
    @FocusState private var whatIsFocused: BuilderFocused?
    @AppStorage("invoiceNote") var invoiceNote: String = ""
    @State private var firstNumber: String?
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("Settings")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.brandBlack)
                .padding(.top, 20)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    
                    Text("Invoice number")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.brandBlack)
                    
                    Spacer()
                    
                    if let firstNumber, firstNumber != viewModel.invoiceDetails.invoiceNumber {
                        
                        Button {
                            withAnimation {
                                if let restartNum = Int64(firstNumber) {
                                    viewModel.invoiceDetails.number = restartNum
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.circlepath")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.brandBlack)
                                .frame(width: 35, alignment: .trailing)
                                .padding(.trailing, 5)
                        }
                        
                    }
                    
                    TextField("2024001 or 1", value: $viewModel.invoiceDetails.number, format: .number.grouping(.never))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .keyboardType(.numberPad)
                        .focused($whatIsFocused, equals: .number)
                        .padding(7)
                        .frame(width: 150, alignment: .trailing)
                        .background(.brandWhite.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 13, style: .continuous))
                        .background {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .strokeBorder(Color.brandBlack, lineWidth: 2)
                        }
                    
                    
                    
                }.padding(.horizontal, 10)
                    .frame(height: 55)
                    .background(.brandGray)
                    .clipShape(.rect(cornerRadius: 17, style: .continuous))
                    .onAppear {
                        withAnimation {
                            firstNumber = viewModel.invoiceDetails.invoiceNumber
                        }
                    }
                
                HStack {
                    
                    Text("Date of issue")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.brandBlack)
                    
                    Spacer()
                    
                    DatePicker("", selection: $viewModel.invoiceDetails.dateCreated, displayedComponents: .date)
                    
                }.padding(.horizontal, 10)
                    .frame(height: 55)
                    .background(.brandGray)
                    .clipShape(.rect(cornerRadius: 17, style: .continuous))
                
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
                        .focused($whatIsFocused, equals: .note)
                        .submitLabel(.return)
                        .padding(10)
                        .background(.brandWhite.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 13, style: .continuous))
                        .background {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .strokeBorder(Color.brandBlack, lineWidth: 2)
                        }
                    
                    
                }.padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(.brandGray)
                    .clipShape(.rect(cornerRadius: 17, style: .continuous))
                    .task {
                        withAnimation {
                            viewModel.invoiceDetails.note = invoiceNote
                        }
                    }
                
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    if whatIsFocused == .note {
                        saveButton
                    } else if whatIsFocused == .number {
                        doneButton
                    }
                }
            }
        }
    }
    
    var saveButton: some View {
        HStack {
            Spacer()
            Button {
                invoiceNote = viewModel.invoiceDetails.note
                whatIsFocused = nil
            } label: {
                Text("Save")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background { Color.brandBlack }
                    .clipShape(Capsule())
                    .frame(width: 120, alignment: .trailing)
            }
        }
    }
    
    var doneButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.invoiceDetails.formatNumber()
                whatIsFocused = nil
            } label: {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background { Color.brandBlack }
                    .clipShape(Capsule())
            }.frame(width: 75)
        }
    }
    
}
