//
//  InvoiceBuilderItemBubble.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

struct InvoiceBuilderItemBubble: View {
    
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
    
    @State var isRetracted = true
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
            
            HStack(alignment: isRetracted ? .lastTextBaseline : .center) {
                
                var foregroundTextColor: Color {
                    
                    if active {
                        return Color.brandBlack
                    } else {
                        return Color.brandBlack.opacity(0.6)
                    }
                    
                }
                
                VStack(alignment: .leading, spacing: 0) {
                
                    TextField("Name", text: $title, onEditingChanged: { _ in
                        withAnimation { title = viewModel.changeTitle(of: itemID, to: title) }
                    })
                    .font(.system(size: isRetracted ? 21 : 23, weight: .medium))
                    .foregroundStyle(foregroundTextColor)
                    .multilineTextAlignment(.leading)
                    .submitLabel(.done)
                    .disabled(isRetracted)
                    .lineLimit(1)
                
                    if isRetracted {
                        Text("count: \(pieces)")
                            .font(.system(size: 12))
                            .foregroundStyle(foregroundTextColor)
                            .lineLimit(1)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                
                Spacer()
                
                if isRetracted {
                    VStack(alignment: .trailing, spacing: 0) {
                        
                        Text("VAT not included")
                            .font(.system(size: 10))
                            .foregroundStyle(foregroundTextColor)
                            .multilineTextAlignment(.trailing)
                        
                        Text(stringToDouble(from: price), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(foregroundTextColor)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                            
                    }.transition(.scale.combined(with: .opacity))
                    
                } else {
                   
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            isRetracted = true
                        }
                    } label: {
                        Text("Done")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.brandBlack)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 7)
                            .background(.brandWhite)
                            .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    }.transition(.scale.combined(with: .opacity))
                    
                }
                
            }
            
            if isRetracted {
                
                HStack(spacing: 10) {
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            impactHeavy.impactOccurred()
                            active = viewModel.toggleVisibility(of: itemID, from: active)
                        }
                        viewModel.madeChanges = true
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.brandBlack)
                            
                            Text(active ? "Exclude" : "Include")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.brandBlack)
                        }.frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(.brandWhite)
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    }
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            if !active {
                                impactHeavy.impactOccurred()
                                active = viewModel.toggleVisibility(of: itemID, from: active)
                            }
                            isRetracted = false
                        }
                        viewModel.madeChanges = true
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "pencil")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.brandBlack)
                            
                            Text("Edit")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.brandBlack)
                        }.frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(.brandWhite)
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    }
                    
                }.padding(.top, 4).transition(.opacity.combined(with: .move(edge: .bottom)))
                
            } else {
                
                RoundedRectangle(cornerRadius: 9)
                    .foregroundStyle(Color.brandWhite)
                    .frame(height: 2)
                    .padding(.vertical, 5)
                
                
                HStack {
                    
                    Spacer()
                    
                    InvoiceItemInput(title: "Count", value: $pieces, unit: UnitsOfMeasurement.piece) {
                        withAnimation {
                            pieces = doubleToString(from: viewModel.changePieces(of: itemID, to: stringToDouble(from: pieces)))
                        }
                    }
                    
                    
                    Spacer()
                    
                    InvoiceItemInput(title: "VAT", value: $vat, unit: UnitsOfMeasurement.percentage) {
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
                    
                    InvoiceItemPriceInput(title: "without VAT", value: $price) {
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
                
            }
            
        }.frame(maxWidth: .infinity)
            .padding(isRetracted ? 10 : 15)
            
            .background(category == .material ? .brandMaterialGray.opacity(active ? 1.0 : 0.5) : .brandGray.opacity(active ? 1.0 : 0.5))
            .clipShape(RoundedRectangle(cornerRadius: isRetracted ? 21 : 28, style: .continuous))
            .task {
                withAnimation {
                    pieces = doubleToString(from: item.pieces)
                    price = doubleToString(from: item.price)
                    vat = doubleToString(from: item.vat)
                }
            }
        
    }
}
