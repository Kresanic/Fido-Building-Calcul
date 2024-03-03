//
//  AppearancePrefferanceView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 10/01/2024.
//

import SwiftUI

struct AppearancePreferenceView: View {
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Text("Appearance")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .padding(.bottom, 15)
                
                AppearanceOptions()
                
            }.padding(.horizontal, 15)
            
        }
        
    }
    
}
