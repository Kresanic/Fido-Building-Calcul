//
//  OnboardingButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

struct OnboardingButton: View {
    
    var isFinalPage = false
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Text(isFinalPage ? "Done!" : "Continue")
                .font(.system(size: 23, weight: .medium))
            
            Image(systemName: isFinalPage ? "flag.circle.fill" : "arrow.right.circle.fill")
                .font(.system(size: 23))
            
            Spacer()
            
        }.foregroundStyle(Color.brandWhite)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.brandBlack)
            .clipShape(Capsule())
            .padding(.horizontal, 25)
            .padding(.bottom, 15)
        
    }
    
}
