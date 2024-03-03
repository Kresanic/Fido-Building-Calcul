//
//  RoomInputsParts.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct ValueEditingBox: View {
    
    var title: DimensionCallout
    @Binding var value: String
    var unit: UnitsOfMeasurment
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(DimensionCallout.readableSymbol(title))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 55, alignment: .trailing)
            
            TextField("0", text: $value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                //.padding(.horizontal, 5)
            
            Text(UnitsOfMeasurment.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 40, alignment: .leading)
            
        }.padding(.horizontal, 15)
        
    }
    
}

struct ValueEditingBoxSmall: View {
    
    var title: DimensionCallout
    @Binding var value: String
    var unit: UnitsOfMeasurment
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Text(DimensionCallout.readableSymbol(title))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 44, alignment: .trailing)
            
            TextField("0", text: $value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 25)
                .frame(maxWidth: .infinity)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            
            Text(UnitsOfMeasurment.readableSymbol(unit))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .minimumScaleFactor(0.7)
                .frame(width: 13)
            
        }
        
    }
    
}

struct CustomWorkPriceEditingBox: View {
    
    var title: DimensionCallout
    @Binding var price: String
    var unit: CustomWorkUnits
    var isMaterial: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 15) {
                
                Text(DimensionCallout.readableSymbol(title))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .frame(width: 65, alignment: .trailing)
                    .fixedSize()
                
                TextField("0,00", text: $price)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(isMaterial ? Color.brandMaterialGray : Color.brandGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                HStack {
                    Text("\(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")/")
                    +
                    Text(CustomWorkUnits.readableSymbol(unit))
                }
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 65, alignment: .leading)
                
            }
        }
    }
    
}

struct CustomWorkValueEditingBox: View {
    
    var title: DimensionCallout
    @Binding var value: String
    var unit: CustomWorkUnits
    var isMaterial: Bool = false
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(DimensionCallout.readableSymbol(title))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 65, alignment: .trailing)
            
            TextField("0", text: $value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(isMaterial ? Color.brandMaterialGray : Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(CustomWorkUnits.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 65, alignment: .leading)
            
        }
        
    }
    
}

struct CustomMaterialPriceEditingBox: View {
    
    var title: DimensionCallout
    @Binding var price: String
    var unit: CustomMaterialUnits
    var isMaterial: Bool = false
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(DimensionCallout.readableSymbol(title))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 50)
            
            TextField("0,00", text: $price)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(isMaterial ? Color.brandMaterialGray : Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            HStack {
                Text("\(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")/")
                +
                Text(CustomMaterialUnits.readableSymbol(unit))
            }
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 50)
            
        }
        
    }
    
}

struct CustomMaterialValueEditingBox: View {
    
    var title: DimensionCallout
    @Binding var value: String
    var unit: CustomMaterialUnits
    var isMaterial: Bool = false
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Text(DimensionCallout.readableSymbol(title))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 50)
            
            TextField("0", text: $value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(isMaterial ? Color.brandMaterialGray : Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(CustomMaterialUnits.readableSymbol(unit))
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 50)
            
        }
        
    }
    
}
