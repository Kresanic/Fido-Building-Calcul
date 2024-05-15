//
//  CustomTabView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI
import RevenueCat

struct FidoTabView: View {
    
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @EnvironmentObject var pricingCalculations: PricingCalculations
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            switch behaviourVM.currentTab {
                
            case .projects:
                ProjectsScreen()
                    .zIndex(0)
                    .transition(.opacity)
            case .invoices:
                InvoicesScreen(activeContractor: behaviourVM.activeContractor)
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
        .sheet(isPresented: $behaviourVM.givenPromotional) { GivenPromotionalSheet() }
        .fullScreenCover(isPresented: $behaviourVM.hasNotSeenOnboarding) { Onboarding() }
        .onChange(of: behaviourVM.promotionalEntitlements, perform: { _ in
            Task { await behaviourVM.windowingForPromotionalEntitlements() }
        })
        .task {
            if !behaviourVM.hasNotSeenOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    Task { await behaviourVM.proEntitlementHandling() }
                }
            }
        }
        
    }
    
}
