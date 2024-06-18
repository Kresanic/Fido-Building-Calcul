//
//  InvoiceBuilderItemBubble.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 24/04/2024.
//

import SwiftUI

enum InvoiceBuilderItemFocuses {
    
    case count, pricePerPiece, VAT, withoutVAT, textField
    
    var advance: Self? {
        switch self {
        case .count:
            .pricePerPiece
        case .pricePerPiece:
            .VAT
        case .VAT:
            .withoutVAT
        case .withoutVAT:
            nil
        case .textField:
            nil
        }
    }
    
}

struct InvoiceBuilderItemBubble: View {
    
    @ObservedObject var viewModel: InvoiceBuilderViewModel
    
    var item: InvoiceItem
    
    @State var itemID: UUID
    @State var title: String
    @State var pieces: String
    @State var price: String
    @State var pricePerPiece: String
    @State var vat: String
    @State var unit: UnitsOfMeasurement
    @State var category: InvoiceItemCategory
    @State var active: Bool
    @Binding var isItemFocused: Bool
    @FocusState var focused: InvoiceBuilderItemFocuses?
    var scrollProxy: ScrollViewProxy
    @State var isRetracted = true
    let backgroundColor: Color
    let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
    @Environment(\.locale) var locale
    
    init(viewModel: InvoiceBuilderViewModel, item: InvoiceItem, isItemFocused: Binding<Bool>, _ scrollProxy: ScrollViewProxy ) {
        self.viewModel = viewModel
        self.item = item
        _itemID = State(initialValue: item.id)
        _title = State(initialValue: NSLocalizedString(item.title.stringKey ?? "", comment: ""))
        _pieces = State(initialValue: item.pieces.toString)
        _price = State(initialValue: item.price.toString)
        _vat = State(initialValue: item.vat.toString)
        _pricePerPiece = State(initialValue: item.pricePerPiece.toString)
        _unit = State(initialValue: item.unit)
        _category = State(initialValue: item.category)
        _active = State(initialValue: item.active)
        _isItemFocused = isItemFocused
        self.scrollProxy = scrollProxy
        backgroundColor = item.category == .material ? .brandMaterialGray.opacity(item.active ? 1.0 : 0.5) : .brandGray.opacity(item.active ? 1.0 : 0.5)
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
                        
                    })
                    .font(.system(size: isRetracted ? 21 : 24, weight: .medium))
                    .foregroundStyle(foregroundTextColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(item.category == .other ? 1...4 : 1...1)
                    .onSubmit { focused = focused?.advance }
                    .focused($focused, equals: .textField)
                    .submitLabel(.done)
                    .disabled(isRetracted)
                    
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
                            active = viewModel.invoiceDetails.toggleVisibility(of: itemID, from: active)
                        }
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
                                active = viewModel.invoiceDetails.toggleVisibility(of: itemID, from: active)
                            }
                            isRetracted = false
                        }
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
                
                VStack {
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        
                        InvoiceItemInput(title: "Count", value: $pieces, unit: UnitsOfMeasurement.piece)
                            .focused($focused, equals: .count)
                        
                        InvoiceItemInput(title: "Price per piece", value: $pricePerPiece)
                            .focused($focused, equals: .pricePerPiece)
                        
                        InvoiceItemInput(title: "VAT", value: $vat, unit: UnitsOfMeasurement.percentage)
                            .focused($focused, equals: .VAT)
                        
                        InvoiceItemInput(title: "Without VAT", value: $price)
                            .focused($focused, equals: .withoutVAT)
                        
                    }
                    
                }
                .padding(.vertical, 15)
                    .background(.brandWhite)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    .padding(.vertical, 10)
                    
                VStack(alignment: .trailing) {
                    
                    let priceD = stringToDouble(from: price)
                    let vatD = stringToDouble(from: vat)
                    let vatTotal = (priceD * vatD/100)
                    
                    InvoiceItemPriceInfo(title: "VAT", value: vatTotal)
                    
                    let totalPrice = priceD * (vatD/100 + 1)
                    
                    InvoiceItemPriceInfo(title: "Total price", value: totalPrice, big: true)
                    
                }.frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            
        }.frame(maxWidth: .infinity)
            .padding(isRetracted ? 10 : 15)
            .background { backgroundColor.onTapGesture { dismissKeyboard() }.ignoresSafeArea() }
            .clipShape(RoundedRectangle(cornerRadius: isRetracted ? 21 : 28, style: .continuous))
            .onChange(of: isRetracted) { value in
                if !value {
                    withAnimation { scrollProxy.scrollTo(item.id, anchor: .top) }
                    focused = .count
                }
            }
            .onChange(of: focused) { value in
                if value != nil {
                    withAnimation { scrollProxy.scrollTo(item.id, anchor: .top) }
                }
            }
            .invoiceBuilderToolbar(focused: $focused,
                                   viewModel: viewModel,
                                   itemID: itemID,
                                   $title,
                                   $pieces,
                                   $pricePerPiece,
                                   $vat,
                                   $price)
        
    }
     
}
