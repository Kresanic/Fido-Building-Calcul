//
//  Onboarding.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 20/11/2023.
//

import SwiftUI
import RevenueCat

struct Onboarding: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    @Environment(\.locale) var locale
    @Environment(\.dismiss) var dismiss
    @State var currentIndex = 0
    @State var emailInput = ""
    @State var hasApprovedEmail = false
    @State var checkSize: CGFloat = 21
    @State var isWrongStructureOfEmail = false
    @State var fastRouteCheck = false
    @FocusState var isFocused: Bool
    @AppStorage("customerEmail") var customerEmail = ""
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        
        VStack {
            
            switch currentIndex {
            case 0:
                landing
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(0)
            case 1:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.mainPriceList, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(1)
            case 2:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.projectPriceList, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(2)
            case 3:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.rooms, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(3)
            case 4:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.clients, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(4)
            case 5:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.newProject, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(5)
            case 6:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.settings, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(6)
            case 7:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.priceListWork, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(7)
            case 8:
                OnboardingPageView(onboardingPageInfo: OnboardingPageContexts.priceListMaterial, currentIndex: $currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(8)
            case 9:
                emailGathering
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(9)
            default:
                landing
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                    .zIndex(0)
                    .onAppear { currentIndex = 0 }
            }
            
        }.padding(.horizontal, 20)
            .background {Color.brandWhite.onTapGesture { dismissKeyboard() }.ignoresSafeArea() }
            .overlay(alignment: .topTrailing) {
                Button {
                    Task {
                        behaviours.hasNotSeenOnboarding = false
                        dismiss()
                        await behaviours.proEntitlementHandling()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.brandGray)
                        .frame(width: 44, height: 44)
                        .padding(15)
                }
            }
        
    }
    
    var landing: some View {
        
        VStack(spacing: 0) {
            Spacer()
            
            Image(.splashLogo)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 200)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Text("FIDO Building Calcul")
                .font(.system(size: 35, weight: .heavy))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.brandBlack)
                .padding(.bottom, 25)
            
            Text("This app will save you hours spent in creating budgets. With the FIDO building calcul app, the budget will be ready in just a few minutes. The app calculates the cost of labor and materials needed for the reconstruction of a house, apartment, etc.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { currentIndex = 1 }
            } label: {
                OnboardingButton()
            }
            
        }.frame(maxWidth: .infinity)
        
    }
    
    var emailGathering: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            Text("Set email for communication")
                .font(.system(size: 35, weight: .heavy))
                .foregroundStyle(Color.brandBlack)
                .padding(.bottom, 25)
                .multilineTextAlignment(.center)
            
            Text("We will use your email only to contact you about your subscription or when there is something new about the app.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if fastRouteCheck && !isWrongStructureOfEmail {
                Text("Do you really want leave empty email?")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .padding(.bottom, 5)
                    .transition(.move(edge: .bottom))
            }
            
            if isWrongStructureOfEmail && !fastRouteCheck && hasApprovedEmail {
                Text("Wrong structure of the email.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.brandRed)
                    .padding(.bottom, 2)
                    .transition(.move(edge: .bottom))
            }
            
            TextField("", text: $emailInput)
                .font(.system(size: 23, weight: .semibold))
                .foregroundStyle(.brandBlack)
                .focused($isFocused)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.vertical, 10)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                .keyboardType(.emailAddress)
                .submitLabel(.continue)
                .overlay {
                    if emailInput.isEmpty {
                        Text("customer@email.com")
                            .font(.system(size: 23, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .opacity(0.5)
                            .allowsHitTesting(false)
                    }
                }
                .overlay(alignment: .trailing) {
                    Button { withAnimation { emailInput = "" } } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color.brandWhite)
                            .padding(.horizontal, 15)
                    }
                }
            
            HStack {
                
                Button {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    withAnimation { hasApprovedEmail.toggle(); impactLight.impactOccurred() }
                } label: {
                    Image(systemName: hasApprovedEmail ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: checkSize))
                        .foregroundStyle(checkSize == 21 ? .brandBlack : .brandRed)
                        .frame(width: 35, height: 35)
                }
                
                let url = (locale.identifier.hasPrefix("sk") || locale.identifier.hasPrefix("cz")) ? "https://www.fido.sk/privacy-policy#svk" : "https://www.fido.sk/privacy-policy#eng"
                
                Text("I agree to receiving sparse email communication regarding my subscription and improvements of the app. **[Check our privacy policy here.](\(url))**")
                    .font(.system(size: 10))
                
            }.foregroundStyle(.brandBlack)
                .padding(.vertical, 15)
            
            Button {
                confirmationLogic()
                
            } label: {
                HStack {
                    
                    Spacer()
                    
                    Text(fastRouteCheck ? "Yes" : "Save!")
                        .font(.system(size: 23, weight: .medium))
                    
                    Image(systemName: "flag.circle.fill")
                        .font(.system(size: 23))
                    
                    Spacer()
                    
                }.foregroundStyle(Color.brandWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.brandBlack)
                    .clipShape(Capsule())
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                    .opacity(hasApprovedEmail && emailInput != "" ? 1.0 : 0.7)
            }
            
        }
        .frame(maxWidth: .infinity)
        .background{ Color.brandWhite.ignoresSafeArea().onTapGesture { dismissKeyboard() } }
        .task { if customerEmail != "" { withAnimation { emailInput = customerEmail } }; isFocused = true }
        .onChange(of: emailInput) { _ in
            if emailInput != "" {
                withAnimation(.easeInOut) { fastRouteCheck = false }
            }
        }
        
    }
    
    private func confirmationLogic() {
        
        if emailInput.isEmpty {
            if fastRouteCheck {
                Task {
                    Purchases.shared.attribution.setEmail(nil)
                    customerEmail = ""
                    behaviours.hasNotSeenOnboarding = false
                    await behaviours.proEntitlementHandling()
                    dismiss()
                }
            } else {
                impactHeavy.impactOccurred()
                withAnimation(.bouncy) { isWrongStructureOfEmail = false ; fastRouteCheck = true }
            }
        } else {
            if hasApprovedEmail {
                setEmail()
            } else {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0.4)) {
                    impactHeavy.impactOccurred()
                    checkSize = 24
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation(.easeInOut) {
                        checkSize = 21
                    }
                }
            }
        }
        
    }
    
    private func setEmail() {
        
        if isValidEmail() {
            withAnimation { isWrongStructureOfEmail = false }
            Task {
                Purchases.shared.attribution.setEmail(emailInput)
                customerEmail = emailInput
                behaviours.hasNotSeenOnboarding = false
                dismiss()
                await behaviours.proEntitlementHandling()
            }
        } else {
            withAnimation(.bouncy) {
                impactHeavy.impactOccurred()
                isWrongStructureOfEmail = true
            }
        }
        
    }
    
    private func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailInput)
    }
    
}
