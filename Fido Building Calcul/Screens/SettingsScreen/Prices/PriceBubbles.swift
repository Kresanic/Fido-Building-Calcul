//
//  PriceBubbles.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct PriceBubble: View {
    
    var title: LocalizedStringKey
    var subTitle: LocalizedStringKey
    @Binding var price: String
    var unit: UnitsOfMeasurement
    @ObservedObject var viewModel: PricesScreenViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    if subTitle != "" {
                        Text(subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .textCase(.lowercase)
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                    }
                    
                }
                
                Spacer()
                
                if unit == .percentage {
                    
                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    Text(UnitsOfMeasurement.readableSymbol(unit))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
                    
                } else {
                    
                    TextField("0,00", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    HStack {
                        Text(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text("/")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text(UnitsOfMeasurement.readableSymbol(unit))
                            .font(.system(size: 16, weight: .medium))
                    }.foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
                    
                }
            }
            
        }.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
            }
            
        
    }
    
}

struct PriceWorkBubble: View {
    
    var work: WorkType.Type
    @Binding var price: String
    @ObservedObject var viewModel: PricesScreenViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(work.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    if work.subTitle != "" {
                        Text(work.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .textCase(.lowercase)
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                    }
                    
                }
                
                Spacer()
                
                if work.unit == .percentage {
                    
                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    Text(UnitsOfMeasurement.readableSymbol(work.unit))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
                    
                } else {
                    
                    TextField("0,00", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    HStack {
                        Text(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text("/")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text(UnitsOfMeasurement.readableSymbol(work.unit))
                            .font(.system(size: 16, weight: .medium))
                    }.frame(width: 55)
                    
                }
            }
            
        }.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
            }
        
    }
    
}

struct PriceMaterialBubble: View {
    
    var material: MaterialType.Type
    @Binding var price: String
    @ObservedObject var viewModel: PricesScreenViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(material.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    if material.subTitle != "" {
                        Text(material.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .textCase(.lowercase)
                            .foregroundStyle(Color.brandBlack)
                            .lineLimit(1)
                    }
                    
                }
                
                Spacer()
                
                if material.unit == .percentage {
                    
                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    Text(UnitsOfMeasurement.readableSymbol(material.unit))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
                    
                } else {
                    
                    TextField("0,00", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    HStack {
                        Text(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text("/")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text(UnitsOfMeasurement.readableSymbol(material.unit))
                            .font(.system(size: 16, weight: .medium))
                    }.foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
                    
                }
            }
            
        }.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.brandMaterialGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
            }
            
        
    }
    
}

struct PriceMaterialBubblePackageBased: View {
    
    var material: MaterialType.Type
    @Binding var price: String
    @Binding var capacity: String
    @ObservedObject var viewModel: PricesScreenViewModel
    @FocusState var isFocused: Bool
    var hasKgNote = false
    
    var body: some View {
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(material.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    if material.subTitle != "" {
                        Text(material.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                    }
                    
                }
                
                Spacer()
                
                if material.unit == .percentage {
                    
                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    Text(UnitsOfMeasurement.readableSymbol(material.unit))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 45)
                    
                } else {
                    
                    TextField("0,00", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    HStack {
                        Text(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text("/")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text(UnitsOfMeasurement.readableSymbol(material.capacityUnity ?? .package))
                            .font(.system(size: 16, weight: .medium))
                    }.foregroundStyle(Color.brandBlack)
                    .frame(width: 55)
                    
                }
            }
            
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .foregroundStyle(Color.brandBlack)
                    .frame(maxWidth: .infinity, maxHeight: 1.5)
                
                HStack {
                    
                    Spacer()
                    
                    HStack {
                        if hasKgNote {
                            Text("capacity per ")
                            +
                            Text(material.capacityUnity == .piece ? "piece" : "package 25kg")
                        } else {
                            Text("capacity per ")
                            +
                            Text(material.capacityUnity == .piece ? "piece" : "package")
                        }
                    }.font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    
                    TextField("0", text: $capacity)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 75, height: 35)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    Text(UnitsOfMeasurement.readableSymbol(material.unit))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
            
            }
            
        }.padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 10)
            .background(Color.brandMaterialGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
            }
            
        
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
       let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
}

struct PriceOtherBubble: View {
    
    var other: OtherType.Type
    @Binding var price: String
    @ObservedObject var viewModel: PricesScreenViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(other.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    if other.subTitle != "" {
                        Text(other.subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .textCase(.lowercase)
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                    }
                    
                }
                
                Spacer()
                
                if other.unit == .percentage {
                    
                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                    
                    Text(UnitsOfMeasurement.readableSymbol(other.unit))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)
                    
                } else {
                    
                    TextField("0,00", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)
                        
                    
                    HStack {
                        Text(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text("/")
                            .font(.system(size: 16, weight: .medium))
                        +
                        Text(UnitsOfMeasurement.readableSymbol(other.unit))
                            .font(.system(size: 16, weight: .medium))
                    }.frame(width: 55)
                    
                }
            }
            
        }.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
            }
        
    }
    
}

