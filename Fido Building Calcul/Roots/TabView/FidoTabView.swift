//
//  CustomTabView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

struct FidoTabView: View {
    
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @EnvironmentObject var pricingCalculations: PricingCalculations
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            switch behaviourVM.currentTab {
                
            case .projects:
                ProjectsScreen()
                    .zIndex(0)
                    .transition(behaviourVM.isAnimationCircular ? .asymmetric(insertion: .scale(scale: 0.0, anchor: .bottomLeading).combined(with: .opacity), removal: .opacity)  : .opacity)
            case .invoices:
                InvoicesScreen()
                    .zIndex(0)
                    .transition(.opacity)
            case .clients:
                ClientsScreen()
                    .zIndex(0)
                    .transition(.opacity)
            case .settings:
                SettingsScreen()
                    .zIndex(0)
                    .transition(.opacity)
            }
            
            CustomTabView(activeTab: $behaviourVM.currentTab)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brandWhite)
        .ignoresSafeArea()
        .onAppear { behaviourVM.deleteArchivedProjects() }
        .onAppear { behaviourVM.checkCheckForGeneralPriceList() }
        .fullScreenCover(isPresented: $behaviourVM.hasNotSeenOnboarding) {
            Onboarding()
        }
    }
}
