//
//  SettingsScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI
import RevenueCat

struct SettingsScreen: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    var body: some View {
        
        NavigationStack(path: $behaviours.settingsPath) {
            
            ScrollView {
                
                VStack {
                    
                    ScreenTitle(title: "Settings")
                    
                    AccountStatus()
                        
                    VStack(alignment: .leading, spacing: 5) {
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Preferences")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            NavigationLink(value: SettingsNavigation.archive) {
                                Text("Archive")
                                    .styleOfBubblesInSettings(subTitle: "archived projects, archive duration")
                            }
                            
                            NavigationLink(value: SettingsNavigation.priceOffer) {
                                Text("Price offer")
                                    .styleOfBubblesInSettings(subTitle: "supplier information, validity of price offer")
                            }
                            
                            NavigationLink(value: SettingsNavigation.generalPriceList) {
                                Text("General price list", comment: "in settings")
                                    .styleOfBubblesInSettings(subTitle: "set default price list")
                            }
                            
                            NavigationLink(value: SettingsNavigation.appearance) {
                                Text("Appearance")
                                    .styleOfBubblesInSettings(subTitle: "set appearance of the app")
                            }
                            
                            NavigationLink(value: SettingsNavigation.invoice) {
                                Text("Invoice")
                                    .styleOfBubblesInSettings(subTitle: "invoice settings")
                            }
                            
                        }
                        
                    }.padding(.top, 15)
                    
                    OtherBubbles().padding(.top, 15)
                    
                    Text("Fido Building Calcul")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandBlack)
                        .padding(.top, 15)
                    
                    Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(.brandBlack.opacity(0.7))
                        .padding(.bottom, 5)
                    
                    Text("©Fido, s.r.o. All rights reserved.")
                        .font(.system(size: 12))
                        .foregroundColor(.brandBlack.opacity(0.5))
                        .multilineTextAlignment(.center)
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                
            }.scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .onTapGesture { dismissKeyboard() }
                .navigationDestination(for: Contractor.self) { contractor in
                    ContractorDetailView(contractor: contractor)
                }
                .navigationDestination(for: SettingsNavigation.self) { settingsNav in
                    switch settingsNav {
                    case .archive:
                        ArchiveSettings()
                    case .priceOffer:
                        PriceOfferSettings()
                    case .appearance:
                        AppearancePreferenceView()
                    case .generalPriceList:
                        PricesScreen()
                    case .invoice:
                        InvoiceSettings()
                    }
                }
                
        }
        
    }
    
}
