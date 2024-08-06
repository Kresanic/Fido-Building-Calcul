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
    
    @State private var itemID: UUID
    @State private var title: String
    @State private var pieces: String
    @State private var price: String
    @State private var pricePerPiece: String
    @State private var vat: String
    @State private var unit: UnitsOfMeasurement
    @State private var category: InvoiceItemCategory
    @State private var active: Bool
    @Binding var isItemFocused: Bool
    @FocusState private var focused: InvoiceBuilderItemFocuses?
    var scrollProxy: ScrollViewProxy
    @State private var isRetracted = true
    let backgroundColor: Color
    let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
    @Environment(\.locale) private var locale
    
    init(viewModel: InvoiceBuilderViewModel, item: InvoiceItem, isItemFocused: Binding<Bool>,_ scrollProxy: ScrollViewProxy) {
        self.viewModel = viewModel
        self.item = item
        _itemID = State(initialValue: item.id)
        _title = State(initialValue: NSLocalizedString(item.title.stringKey ?? "", comment: ""))
        _pieces = State(initialValue: item.pieces.toString)
        _price = State(initialValue: item.price.toString)
        _pricePerPiece = State(initialValue: item.pricePerPiece.toString)
        _vat = State(initialValue: item.vat.toString)
        _unit = State(initialValue: item.unit)
        _category = State(initialValue: item.category)
        _active = State(initialValue: item.active)
        _isItemFocused = isItemFocused
        self.scrollProxy = scrollProxy
        self.backgroundColor = item.category == .material ? .brandMaterialGray.opacity(item.active ? 1.0 : 0.5) : .brandGray.opacity(item.active ? 1.0 : 0.5)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            itemHeader
            if isRetracted {
                itemSummary
            } else {
                itemDetails
            }
        }
        .frame(maxWidth: .infinity)
        .padding(isRetracted ? 10 : 15)
        .background(backgroundColor.onTapGesture { dismissKeyboard() }.ignoresSafeArea())
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
        .invoiceBuilderToolbar(focused: $focused, viewModel: viewModel, itemID: itemID, $title, $pieces, $pricePerPiece, $vat, $price)
    }
    
    // Extracted subview for the item header
    @ViewBuilder
    private var itemHeader: some View {
        HStack(alignment: isRetracted ? .lastTextBaseline : .center) {
            VStack(alignment: .leading, spacing: 0) {
                TextField("Name", text: $title, onEditingChanged: { _ in })
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
                    
                    Text(stringToDouble(from: price), format: .currency(code: locale.currency?.identifier ?? "USD"))
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(foregroundTextColor)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: toggleRetractedState) {
                    Text("Done")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 7)
                        .background(.brandWhite)
                        .clipShape(.rect(cornerRadius: 12, style: .continuous))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // Extracted subview for the item summary
    @ViewBuilder
    private var itemSummary: some View {
        VStack {
            actionButtons
            Spacer()
        }
    }
    
    // Extracted subview for the action buttons
    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button(action: toggleVisibility) {
                actionButtonContent(imageName: "doc.text.fill", text: active ? "Exclude" : "Include")
            }
            Button(action: editItem) {
                actionButtonContent(imageName: "pencil", text: "Edit")
            }
        }
        .padding(.top, 4)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    // Extracted subview for the action button content
    @ViewBuilder
    private func actionButtonContent(imageName: String, text: LocalizedStringKey) -> some View {
        HStack(spacing: 3) {
            Image(systemName: imageName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.brandBlack)
            Text(text)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.brandBlack)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(.brandWhite)
        .clipShape(.rect(cornerRadius: 15, style: .continuous))
    }
    
    // Extracted subview for the item details
    @ViewBuilder
    private var itemDetails: some View {
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
            InvoiceItemPriceInfo(title: "VAT", value: calculateVatTotal())
            InvoiceItemPriceInfo(title: "Total price", value: calculateTotalPrice(), big: true)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    // Extracted computed property for the foreground text color
    private var foregroundTextColor: Color {
        active ? Color.brandBlack : Color.brandBlack.opacity(0.6)
    }
    
    // Toggle retracted state
    private func toggleRetractedState() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            isRetracted.toggle()
        }
    }
    
    // Toggle visibility of the item
    private func toggleVisibility() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            impactHeavy.impactOccurred()
            active = viewModel.invoiceDetails.toggleVisibility(of: itemID, from: active)
        }
    }
    
    // Edit item
    private func editItem() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            if !active {
                impactHeavy.impactOccurred()
                active = viewModel.invoiceDetails.toggleVisibility(of: itemID, from: active)
            }
            isRetracted = false
        }
    }
    
    // Calculate VAT total
    private func calculateVatTotal() -> Double {
        let priceD = stringToDouble(from: price)
        let vatD = stringToDouble(from: vat)
        return priceD * vatD / 100
    }
    
    // Calculate total price
    private func calculateTotalPrice() -> Double {
        let priceD = stringToDouble(from: price)
        let vatD = stringToDouble(from: vat)
        return priceD * (vatD / 100 + 1)
    }
}
