//
//  GivenPromotionalSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 03/04/2024.
//

import SwiftUI

struct GivenPromotionalSheet: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Spacer()
            
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 100, weight: .regular))
                .padding(.bottom, 40)
            
            Text("\(behaviours.givePromotionalForMonths) Months on Us!")
                .font(.system(size: 37, weight: .bold))
            
            Text("You have been granted full access to the app for a period of \(behaviours.givePromotionalForMonths) months to fully experience its features and functionalities.")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            
            Button { dismiss() } label: {
                Text("Thank you!")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.brandGray)
                    .clipShape(.rect(cornerRadius: 15, style: .continuous))
            }
            
        }
        .foregroundStyle(.brandBlack)
        .padding(.horizontal, 15)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .presentationCornerRadius(30)
        .presentationBackground(.brandWhite)
        
    }
    
}
