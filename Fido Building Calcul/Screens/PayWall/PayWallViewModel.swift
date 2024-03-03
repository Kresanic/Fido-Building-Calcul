//
//  PayWallViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/10/2023.
//

import SwiftUI
import RevenueCat

@MainActor final class PayWallViewModel: ObservableObject {
    
    @Published var currentPackages: [Package] = []
    @Published var failedToFetchOfferings = false
    @Published var selectedPackage: Package?
    @Published var hideStatusBar = false
    @Published var isPurchasing = false
    @Namespace private var payWallNameID
    
    func toggleIsPurchasing() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPurchasing.toggle()
        }
    }
    
    @Published var legalNotice: LocalizedStringKey = "Unlock premium features with a subscription. By subscribing, you agree to our terms of service and privacy policy. Your subscription will automatically renew unless canceled at least 24 hours before the end of the current period. You can manage or cancel your subscription in your App Store account settings at any time."
    
}

