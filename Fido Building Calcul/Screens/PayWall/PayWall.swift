//
//  PayWall.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/10/2023.
//

import SwiftUI
import RevenueCat

struct PayWallScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var environmentVM: BehavioursViewModel
    @StateObject private var viewModel = PayWallViewModel()
    
    var body: some View {
            
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 10) {
                
                HStack(alignment: .lastTextBaseline) {
                        
                    Text("Become Pro!")
                        .font(.system(size: 33, weight: .semibold))
                        .foregroundColor(.brandBlack)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 23, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: 44, height: 44, alignment: .leading)
                    }
                    
                }.padding(.top, 15)
                    .padding(.horizontal, 15)
                
                PayWallFeature()

                if viewModel.currentPackages.isEmpty {
                    
                    if viewModel.failedToFetchOfferings {
                        
                        Text("Something went wrong with the offers. Try again or please contact us at info@fido.sk")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.brandBlack)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 15)
                        
                    } else {
                        
                        OfferingBubblePreview()
                            .padding(.horizontal, 15)
                        
                        OfferingBubblePreview()
                            .padding(.horizontal, 15)
                        
                    }
                    
                } else {
                    
                    Text("Options")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    ForEach(viewModel.currentPackages) { pkg in
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.selectedPackage = pkg
                            }
                        } label: {
                            OfferingBubble(isSelected: pkg == viewModel.selectedPackage, package: pkg)
                                .transition(.scale.combined(with: .opacity))
                                .onAppear {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                                        if pkg.storeProduct.subscriptionPeriod?.unit == .year {
                                            viewModel.selectedPackage = pkg
                                        }
                                    }
                                }
                        }
                        
                    }.padding(.horizontal, 15)
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                            viewModel.isPurchasing = true
                        }
                        if viewModel.selectedPackage != nil {
                            
                            Purchases.shared.purchase(package: viewModel.selectedPackage!) { (transaction, customerInfo, error, userCancelled) in
                                
                                if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                                        viewModel.toggleIsPurchasing()
                                        environmentVM.isUserPro = true
                                        dismiss()
                                    }
                                } else if userCancelled {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                                        viewModel.isPurchasing = false
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                                        viewModel.isPurchasing = false
                                    }
                                }
                                
                            }
                            
                        } else {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                                viewModel.isPurchasing = false
                            }
                        }
                    } label: {
                        if viewModel.isPurchasing {
                            LoadingBubble()
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            PurchaseButton(hasFreeTrail: true)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }.padding(.top, 10)
                        .padding(.horizontal, 15)
                    
                }
                
                Text(viewModel.legalNotice)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.brandBlack)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                HStack(spacing: 0) {
                    
                    Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") ?? URL(string: "https://www.fido.sk/privacy-policy")!)
                    
                    Text(" • ")
                    
                    Button {
                        viewModel.toggleIsPurchasing()
                        Purchases.shared.restorePurchases { (customerInfo, error) in
                            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                                viewModel.toggleIsPurchasing()
                                viewModel.isPurchasing = false
                                environmentVM.isUserPro = true
                                dismiss()
                            } else {
                                viewModel.toggleIsPurchasing()
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                    }
                        
                    
                    Text(" • ")
                    
                    Link("Privacy Policy", destination: URL(string: "https://tenu.app/privacypolicy")!)
                        
                    
                }.font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.brandBlack)
                    .padding(.horizontal, 15)
                
            }
                .padding(.bottom, 35)
                .disabled(viewModel.isPurchasing)
                .opacity(viewModel.isPurchasing ? 0.5 : 1.0)
            
        }
            .background(Color.brandGray)
            .statusBarHidden(viewModel.hideStatusBar)
            .ignoresSafeArea(edges: .bottom)
            .task {
                Purchases.shared.getOfferings { offerings, error in
                    guard error == nil else {
                        withAnimation { viewModel.failedToFetchOfferings = true }
                        return
                    }
                    if let packages = offerings?.current?.availablePackages {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.5)) {
                            viewModel.currentPackages = packages
                        }
                    }
                }
            }
            .task {
                withAnimation(.easeOut.delay(0.3)) {
                    viewModel.hideStatusBar = true
                }
            }
    }
}
