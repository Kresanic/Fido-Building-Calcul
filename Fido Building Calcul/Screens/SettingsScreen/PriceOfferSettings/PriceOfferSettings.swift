//
//  PriceOffer.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct PriceOfferSettings: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Text("Price offer")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .padding(.bottom, 15)
                
                ValidityOfPriceOfferView().padding(.bottom, 10)
                
                ContractorView()
                
            }.padding(.horizontal, 15)
            
        }
        
    }
    
}
