//
//  RoomBubbleView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct RoomBubbleView: View {
    
    var room: Room
    var priceList: PriceList
    var isDeleting: Bool
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var priceCalc: PricingCalculations
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    var body: some View {
        
        HStack {
            
            let priceCalc = priceCalc.roomPriceBillCalculation(room: room, priceList: priceList)
            
            VStack(alignment: .leading) {
                    
                Text(RoomTypes.rawValueToString(room.unwrappedName))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                Text("\(priceCalc.worksCount) works")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
            
            }
            
            Spacer()
            
            if !isDeleting {
                
                VStack(alignment: .trailing, spacing: 0) {
                    
                    Text("VAT not included")
                        .font(.system(size: 8))
                        .foregroundStyle(Color.brandBlack)
                    
                    Text(priceCalc.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }.redrawable()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
                
            }
            
        }.padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                    .background(Color.brandGray)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
            }

    }
    
}
