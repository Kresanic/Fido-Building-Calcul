//
//  ValidityOfPriceOffer.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ValidityOfPriceOfferBubble: View {
    
    @AppStorage("priceOfferValidity") var priceOfferValidityAS: Int = 7
    var priceOfferValidity: Int
    
    var body: some View {
        
        Button {
            withAnimation { priceOfferValidityAS = priceOfferValidity }
        } label: {
            Text("\(priceOfferValidity) days")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(priceOfferValidityAS == priceOfferValidity ? Color.brandWhite : Color.brandBlack)
                .minimumScaleFactor(0.7)
                .fixedSize()
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(priceOfferValidityAS == priceOfferValidity ? Color.brandBlack : Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        
    }
    
}

struct ValidityOfPriceOfferView: View {
    
    @AppStorage("priceOfferValidity") private var priceOfferValidity = 7
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "clock.badge.xmark.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Validity of price offer")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    
                    ForEach(ValidityDurations.allCases, id: \.self) { forTime in
                        ValidityOfPriceOfferBubble(priceOfferValidity: forTime.rawValue)
                            .transition(.scale)
                        if forTime != .twoMonths { Spacer() }
                    }
                }
                
                Text("Validity of your price offers will be set for \(priceOfferValidity) days since creation.")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                
            }.padding(15)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        
    }
    
}
