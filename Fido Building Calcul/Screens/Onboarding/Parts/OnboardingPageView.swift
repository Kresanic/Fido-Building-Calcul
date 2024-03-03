//
//  OnboardingPageView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

struct OnboardingPageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var onboardingPageInfo: OnboardingPageInfo
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Text(onboardingPageInfo.title)
                .font(.system(size: 35, weight: .heavy))
                .foregroundStyle(Color.brandBlack)
                .padding(.bottom, 25)
            
            ForEach(onboardingPageInfo.images, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 25)
            }
            
            Text(onboardingPageInfo.description)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                    if onboardingPageInfo.isFinal {
                        dismiss()
                    } else {
                        currentIndex += 1
                    }
                }
            } label: {
                OnboardingButton(isFinalPage: onboardingPageInfo.isFinal)
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

