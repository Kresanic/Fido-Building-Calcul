//
//  Fido_Building_CalculApp.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 26/07/2023.
//

import SwiftUI
import RevenueCat

@main
struct Fido_Building_CalculApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @StateObject var behavioursViewModel = BehavioursViewModel()
    @StateObject var pricingCalculations = PricingCalculations()
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_eEsIiyWisjWbLTkyAMcqCCFUDaB")
    }
    
    var body: some Scene {
        WindowGroup {
            FidoTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(behavioursViewModel)
                .environmentObject(pricingCalculations)
                .sheet(item: $behavioursViewModel.showingDialogWindow) { dialogContent in
                    DialogWindow(dialog: dialogContent)
                }
                .preferredColorScheme(behavioursViewModel.appearancePrefferance())
                .tint(.brandBlack)
        }
    }
}
