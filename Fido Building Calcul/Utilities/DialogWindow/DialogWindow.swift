//
//  DialogWindow.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/11/2023.
//

import SwiftUI

struct DialogWindow: View {
    
    var dialog: Dialog
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
                
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .foregroundStyle(Color.brandGray)
                .frame(width: 30, height: 5)
            
            Spacer()
            
            Text(dialog.title)
                .foregroundStyle(Color.brandBlack)
                .font(.system(size: 25, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            
            Text(dialog.subTitle)
                .font(.system(size: 16))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            Spacer()
            
            HStack {
                
                Spacer()
                
                if dialog.alertType == .warning {
                    Button {
                        dialog.action()
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                        dismiss()
                    } label: {
                        DialogSecondaryButton(title: "Yes")
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        DialogPrimaryButton(title: "No")
                    }
                } else if dialog.alertType == .approval {
                    Button {
                        dismiss()
                    } label: {
                        DialogSecondaryButton(title: "No")
                    }
                    
                    Spacer()
                    
                    Button {
                        dialog.action()
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                        dismiss()
                    } label: {
                        DialogPrimaryButton(title: "Yes")
                    }
                }
                
                Spacer()
                
            }
            
            Spacer()
            
        }.padding(15)
            .padding(.bottom, 30)
            .onAppear {
                let impactMed = UIImpactFeedbackGenerator(style: dialog.alertType == .warning ? .heavy : .medium)
                impactMed.impactOccurred()
            }
            .frame(maxWidth: .infinity)
                .background { Color.brandWhiteBackground.clipShape(.rect(cornerRadius: 40, style: .continuous)).padding(.horizontal, 15).padding(.bottom, 30) }
                .ignoresSafeArea()
                .presentationDetents([.height(260)])
                .presentationCornerRadius(0)
                .presentationBackground(.clear)
                .presentationBackgroundInteraction(.disabled)
        
    }
    
}
