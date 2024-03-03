//
//  AccountSettings.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI
import RevenueCat

struct AccountStatus: View {
    
    @State var isShowingPayWall = false
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @AppStorage("customerEmail") var customerEmail = ""
    @State var isShowingEmailInput = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Access")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 2) {
                
                HStack {
                    
                    Text(customerEmail)
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundStyle(.brandBlack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 10)
                        .keyboardType(.emailAddress)
                        .submitLabel(.continue)
                        .overlay(alignment: .leading) {
                            if customerEmail.isEmpty {
                                Text("customer@email.com")
                                    .font(.system(size: 23, weight: .semibold))
                                    .foregroundStyle(.brandBlack)
                                    .frame(alignment: .leading)
                                    .opacity(0.5)
                                    .allowsHitTesting(false)
                            }
                        }
                        .onTapGesture { isShowingEmailInput = true }
                    
                    Spacer()
                    
                    Button { isShowingEmailInput = true } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color.brandBlack)
                            .padding(.horizontal, 15)
                    }
                    
                }.padding(.leading, 15)
                
                Text(behaviourVM.isUserPro ? "Pro User" : "Restricted Access")
                    .font(.system(size: 20, weight: .semibold))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .padding(.horizontal, 15)
                
                Text(behaviourVM.isUserPro ? "Customise prices in the entire app and export projects to PDF." : "Customise prices in the entire app and export projects to PDF. Try Pro For Free!")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.brandBlack)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                    .padding(.horizontal, 15)
                
                if !behaviourVM.isUserPro {
                    Button {
                        isShowingPayWall = true
                    } label: {
                        Text("Try Pro")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 25)
                            .background(Color.brandWhite)
                            .clipShape(.rect(cornerRadius: 13, style: .continuous))
                            .padding(.top, 5)
                            .padding(.horizontal, 15)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 15)
            .padding(.top, 10)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .onTapGesture { if !behaviourVM.isUserPro { isShowingPayWall = true } }
            .onLongPressGesture(minimumDuration: 0.6) {
                UIPasteboard.general.string = Purchases.shared.appUserID
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
            }
            
        }
        .fullScreenCover(isPresented: $isShowingPayWall) { PayWallScreen() }
        .sheet(isPresented: $isShowingEmailInput) {
            EmailInputSheet()
                .presentationDetents([.fraction(0.7)])
                .presentationCornerRadius(25)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        
    }
    
}
