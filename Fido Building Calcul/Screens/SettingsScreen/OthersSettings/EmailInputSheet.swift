//
//  EmialInputSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 12/02/2024.
//

import SwiftUI
import RevenueCat

struct EmailInputSheet: View {
    
    @AppStorage("customerEmail") var customerEmail = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    @State var emailInput = ""
    @State var hasApprovedEmail = false
    @State var checkSize: CGFloat = 21
    @State var isWrongStructureOfEmail = false
    @State var fastRouteCheck = false
    @FocusState var isFocused: Bool
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            Text("Set email for communication")
                .font(.system(size: 35, weight: .heavy))
                .foregroundStyle(Color.brandBlack)
                .padding(.bottom, 25)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("We will use your email only to contact you about your subscription or when there is something new about the app.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
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
                    .fixedSize(horizontal: false, vertical: true)
                
            }.foregroundStyle(.brandBlack)
                .padding(.vertical, 15)
            
            Button {
                confirmationLogic()
            } label: {
                HStack {
                    
                    Spacer()
                    
                    Text(fastRouteCheck ? "Yes" : "Save!")
                        .font(.system(size: 23, weight: .medium))
                    
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
        .padding(.horizontal, 15)
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
                Purchases.shared.attribution.setEmail(nil)
                customerEmail = ""
                dismiss()
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
            Purchases.shared.attribution.setEmail(emailInput)
            customerEmail = emailInput
            dismiss()
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
