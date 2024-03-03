//
//  Others.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI
import RevenueCat

struct OtherBubbles: View {
    
    @State var isShowingOnboarding = false
    @EnvironmentObject var environmentVM: BehavioursViewModel
    @State var isRestoringPurchases = false
    @Environment(\.locale) var locale
    var isSlovak: Bool { (locale.identifier.hasPrefix("sk") || locale.identifier.hasPrefix("cz") ) ? true : false }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5){
            
            HStack(alignment: .center) {
                
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                
                Text("Others")
                
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(spacing: 8) {
                
                Button {
                    isShowingOnboarding = true
                } label: {
                    
                    Text("Tutorial")
                        .styleOfBubblesInSettings()
                }
                
                Button {
                    if let url = URL(string: "mailto:info@fido.sk") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    
                    Text("Contact")
                        .styleOfBubblesInSettings()
                }
                
                Button {
                    UIApplication.shared.open(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") ?? URL(string: "https://tenu.app/privacypolicy")!)
                } label: {
                    
                    Text("Terms of Use")
                        .styleOfBubblesInSettings()
                }
                
                Button {
                    if isSlovak {
                        UIApplication.shared.open(URL(string: "https://www.fido.sk/privacy-policy#svk")!)
                    } else {
                        UIApplication.shared.open(URL(string: "https://www.fido.sk/privacy-policy#eng")!)
                    }
                } label: {
                    Text("Privacy Policy")
                        .styleOfBubblesInSettings()
                }
                
                if environmentVM.isUserPro == false {
                    Button {
                        Task {
                            Purchases.shared.restorePurchases { (customerInfo, error) in
                                if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                                    environmentVM.isUserPro = true
                                }
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                            .styleOfBubblesInSettings()
                    }
                }
                
            }
            
        }.fullScreenCover(isPresented: $isShowingOnboarding) {
            Onboarding()
        }
    }
    
}

