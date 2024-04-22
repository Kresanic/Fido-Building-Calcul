//
//  InvoiceBuilderView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/04/2024.
//

import SwiftUI


struct InvoiceBuilderView: View {
    
    var project: Project
    @StateObject var viewModel = InvoiceBuilderViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                Text("Invoice Builder")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.brandBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.brandBlack)
                                .frame(width: 60, height: 60)
                                .offset(x: 15)
                        }
                    }
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    let works = viewModel.invoiceItems.filter {$0.category == .work}
                    
                    if !works.isEmpty {
                        Text("Work")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.top, 15)
                        
                        VStack(spacing: 15) {
                            ForEach(works) { item in
                                
                                InvoiceItemBubble(viewModel: viewModel, item: item)
                                
                            }
                        }
                    }
                    
                    let materials = viewModel.invoiceItems.filter({$0.category == .material})
                    if !materials.isEmpty {
                        
                        Text("Material")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.top, 15)
                        
                        VStack(spacing: 15) {
                            ForEach(materials) { item in
                                
                                InvoiceItemBubble(viewModel: viewModel, item: item)
                                
                            }
                        }
                    }
                    
                    let others = viewModel.invoiceItems.filter {$0.category == .other}
                    if !others.isEmpty {
                        Text("Other")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.top, 15)
                        
                        VStack(spacing: 15) {
                            
                            ForEach(others) { item in
                                
                                InvoiceItemBubble(viewModel: viewModel, item: item)
                                
                            }
                        }
                    }
                    
                }
                
                Text("Summary")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.brandBlack)
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    
                    VStack {
                        
                        let priceWithoutVAT = viewModel.invoiceItems.reduce(0.0) {
                            if $1.active {
                                return $0 + $1.price
                            }
                            
                            return $0
                        }
                        
                        let cumulativeVAT = viewModel.invoiceItems.reduce(0.0) { 
                            if $1.active {
                               return $0 + ($1.price * ($1.vat/100))
                            }
                            
                            return $0
                        }
                        
                        let totalPrice = priceWithoutVAT + cumulativeVAT
                        
                        HStack(alignment: .firstTextBaseline) {
          
                            Text("without VAT")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            Text(round(priceWithoutVAT/100)*100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                        }
                        
                        HStack(alignment: .firstTextBaseline) {
                      
                            Text("VAT")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Spacer()
                            
                            
                            
                            Text(round(cumulativeVAT/100)*100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                        }
                        
                        HStack(alignment: .firstTextBaseline) {
            
                            Text("Total price")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                                .minimumScaleFactor(0.4)
                                .lineLimit(1)
                                
                            Spacer(minLength: 20)
                            
                            
                            Text(totalPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .minimumScaleFactor(0.4)
                                .lineLimit(1)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                        }
                        
                    }
                    
                    Button {
                        
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
                            .opacity(0.8)
                    }
                    
                }.padding(15)
                    .background(Color.brandGray)
                    .clipShape(.rect(cornerRadius: 25, style: .continuous))
                    .redrawable()
                
            }.padding(.horizontal, 15)
                .padding(.bottom, 15)
            
        }
        .scrollDismissesKeyboard(.immediately)
        .task { viewModel.populateInvoiceItems(with: project) }
        
    }
    
}

struct InvoiceItemBubble: View {
    
    @ObservedObject var viewModel: InvoiceBuilderViewModel
    var item: InvoiceItem
    @State var itemID: UUID
    @State var title: String
    @State var pieces: String
    @State var price: String
    @State var vat: String
    @State var unit: UnitsOfMeasurement
    @State var category: InvoiceItemCategory
    @State var active: Bool
    let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
    @Environment(\.locale) var locale
    
    init(viewModel: InvoiceBuilderViewModel, item: InvoiceItem) {
        self.viewModel = viewModel
        self.item = item
        _itemID = State(initialValue: item.id)
        _title = State(initialValue: NSLocalizedString(item.title.stringKey ?? "", comment: ""))
        _pieces = State(initialValue: String(item.pieces))
        _price = State(initialValue: String(item.price))
        _vat = State(initialValue: String(item.vat))
        _unit = State(initialValue: item.unit)
        _category = State(initialValue: item.category)
        _active = State(initialValue: item.active)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                TextField("Name", text: $title, onEditingChanged: { _ in
                    withAnimation {
                        title = viewModel.changeTitle(of: itemID, to: title)
                    }
                })
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(.brandBlack)
                .multilineTextAlignment(.leading)
                .submitLabel(.done)
                
                
                Button {
                    withAnimation {
                        impactHeavy.impactOccurred()
                        active = viewModel.toggleVisibility(of: itemID, from: active)
                    }
                } label: {
                    Image(systemName: active ? "eye.fill" : "eye.slash.fill")
                        .font(.system(size: 19))
                        .foregroundStyle(.brandBlack)
                        .frame(width: 36, height: 36)
                        .background(.brandWhite)
                        .clipShape(.rect(cornerRadius: 9, style: .continuous))
                }
                
            }
            
            RoundedRectangle(cornerRadius: 9)
                .foregroundStyle(Color.brandWhite)
                .frame(height: 2)
                .padding(.vertical, 5)
            
            
            HStack {
                
                Spacer()
                
                EditableInvoiceInputBox(title: "Count", value: $pieces, unit: UnitsOfMeasurement.piece) {
                    withAnimation {
                        pieces = doubleToString(from: viewModel.changePieces(of: itemID, to: stringToDouble(from: pieces)))
                    }
                }
                
                
                Spacer()
                
                EditableInvoiceInputBox(title: "VAT", value: $vat, unit: UnitsOfMeasurement.percentage) {
                    withAnimation {
                        vat = doubleToString(from: viewModel.changeVat(of: itemID, to: stringToDouble(from: vat)))
                    }
                }
                
                Spacer()
                
            }
            
            RoundedRectangle(cornerRadius: 9)
                .foregroundStyle(Color.brandWhite)
                .frame(height: 2)
                .padding(.vertical, 5)
            
            VStack(alignment: .trailing) {
                
                EditableInvoicePriceInputBox(title: "without VAT", value: $price) {
                    withAnimation {
                        price = doubleToString(from: viewModel.changeVat(of: itemID, to: stringToDouble(from: price)))
                    }
                }
                
                let priceD = stringToDouble(from: price)
                let vatD = stringToDouble(from: vat)
                
                let vatTotal = (priceD * vatD/100)
                
                InvoiceItemPriceInfo(title: "VAT", value: vatTotal)
                
                let totalPrice = priceD * (vatD/100 + 1)
                
                InvoiceItemPriceInfo(title: "Total price", value: totalPrice, big: true)
                
            }
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .overlay {
                if !active {
                    if category == .material {
                        Color.brandMaterialGray.opacity(0.4).allowsHitTesting(false)
                    } else {
                        Color.brandGray.opacity(0.4).allowsHitTesting(false)
                    }
                }
            }
            .background(category == .material ? .brandMaterialGray : .brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .task {
                withAnimation {
                    pieces = doubleToString(from: item.pieces)
                    price = doubleToString(from: item.price)
                    vat = doubleToString(from: item.vat)
                }
            }
        
    }
}


struct InvoiceItemPriceInfo: View {
    
    var title: String
    var value: Double
    var big: Bool = false
    @Environment(\.locale) var locale
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            
            Text(title)
                .font(.system(size: big ? 23 : 17, weight: big ? .semibold : .medium))
                .foregroundStyle(Color.brandBlack)
            
            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: big ? 23 : 17, weight: big ? .semibold : .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(maxWidth: 150, alignment: .trailing)
            
        }
        
    }
    
}

struct EditableInvoiceInputBox: View {
    
    var title: String
    @Binding var value: String
    var unit: UnitsOfMeasurement
    var editingChanged: () -> Void
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            
            VStack(alignment: .center, spacing: 4) {
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                TextField("0", text: $value, onEditingChanged: { _ in
                    editingChanged()
                })
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(width: 100, height: 37)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
            }
            
            Text(UnitsOfMeasurement.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }
        
    }
    
}

struct EditableInvoicePriceInputBox: View {
    
    var title: String
    @Binding var value: String
    var editingChanged: () -> Void
    @Environment(\.locale) var locale
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Spacer()
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
            TextField("0", text: $value, onEditingChanged: { _ in
                editingChanged()
            })
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.brandBlack)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .frame(width: 100, height: 37)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(maxWidth: 125, alignment: .trailing)
            
            Text(locale.currencySymbol ?? "$")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
        }
        
        
    }
    
}


struct UneditableInvoiceInputBox: View {
    
    var title: String
    var value: String
    var unit: UnitsOfMeasurement
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            
            VStack(alignment: .center, spacing: 4) {
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(width: 100, height: 37)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
            }
            
            Text(UnitsOfMeasurement.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }
        
        
    }
    
}
