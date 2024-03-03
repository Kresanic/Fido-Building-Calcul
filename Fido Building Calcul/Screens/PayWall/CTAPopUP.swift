//
//  CTAPopUP.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/10/2023.
//

import SwiftUI

struct CTAPopUpSheet: View {
    
    @State var isShowingPayWall = false
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 70, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Text("Become Pro!")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
            
            Text("Customise prices in the entire app and export projects to PDF. Try Pro For Free!")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            Button {
                isShowingPayWall = true
            } label: {
                Text("Try Pro")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding(.top, 25)
            }
        
        }.padding(.vertical, 40)
            .frame(maxWidth: .infinity)
            .background(Color.brandWhite)
            .clipShape(.rect(cornerRadius: 35))
            .shadow(color: .brandBlack.opacity(0.2) ,radius: 10)
            .padding(.horizontal, 30)
            .fullScreenCover(isPresented: $isShowingPayWall) { PayWallScreen() }
        
    }
    
}

struct CTAPopUp: ViewModifier {
    
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    
    func body(content: Content) -> some View {
        
        if behaviourVM.isUserPro {
            content
        } else {
            content
                .disabled(true)
                .blur(radius: 3)
                .overlay(alignment: .top) { CTAPopUpSheet().padding(.top, 125) }
                .transition(.opacity)
        }
    }
    
}
