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
    @State var customDuration: String = ""
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    
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
                
                InvoiceMaturitySettings()
                
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
                    .onChange(of: viewModel.invoiceDetails.note) { newValue in
                        invoiceNote = newValue
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
    
    var saveButton: some View {
        HStack {
//            Spacer()
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
            }.frame(maxWidth: .infinity, alignment: .trailing)
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


struct InvoiceMaturitySettings: View {
    
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    @State var customMaturityNumber = 30
    @State var newCustomMaturityNumber: Int?
    @FocusState var isCustomFocused: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Invoice maturity")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.brandBlack)
            
            GeometryReader { geo in
                
                HStack(spacing: 4) {
                    
                    let sixthOfWidth = (geo.size.width-20)/6
                    
                    ForEach(MaturityDuration.allCases, id: \.self) { forTime in
                        
                        Button {
                            withAnimation { customMaturityNumber = forTime.rawValue }
                        } label: {
                            
                            VStack(alignment: .center, spacing: 0) {
                                
                                Text(forTime.rawValue, format:.number.precision(.fractionLength(0)))
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("days")
                                    .font(.system(size: 13, weight: .medium))
                                
                            }
                            
                        }.foregroundStyle(customMaturityNumber == forTime.rawValue ? .brandWhite : .brandBlack)
                            .frame(width: sixthOfWidth, height: sixthOfWidth)
                            .background(customMaturityNumber == forTime.rawValue ? .brandBlack : .brandGray)
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                        
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                            
                        TextField("XY", value: $newCustomMaturityNumber, format: .number)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.brandWhite)
                            .focused($isCustomFocused)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .keyboardType(.numberPad)
                        
                        Text("days")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(MaturityDuration(rawValue: customMaturityNumber) == nil ? .brandWhite : .brandBlack)
                        
                    }.frame(width: sixthOfWidth, height: sixthOfWidth)
                        .background(MaturityDuration(rawValue: customMaturityNumber) == nil ? .brandBlack : .brandGray)
                        .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    
                }
                
            }.padding(10)
                .background(.brandWhite)
                .clipShape(.rect(cornerRadius: 25, style: .continuous))
                .frame(height: 70)
                .onAppear {
                    customMaturityNumber = invoiceMaturityDuration
                    if MaturityDuration(rawValue: customMaturityNumber) == nil {
                        newCustomMaturityNumber = customMaturityNumber
                    }
                }
                .onChange(of: customMaturityNumber) { num in
                    withAnimation {
                        if num >= 0 {
                            invoiceMaturityDuration = num
                        }
                        if MaturityDuration(rawValue: num) != nil {
                            newCustomMaturityNumber = nil
                        }
                    }
                }
                .onChange(of: newCustomMaturityNumber) { num in
                    withAnimation {
                        if let num, num >= 0 {
                            customMaturityNumber = num
                        }
                    }
                }
                
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(.brandGray)
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                if isCustomFocused == true {
                    doneButton
                }
            }
        }
        
    }
    
    var doneButton: some View {
        HStack {
            Spacer()
            Button {
                isCustomFocused = false
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
