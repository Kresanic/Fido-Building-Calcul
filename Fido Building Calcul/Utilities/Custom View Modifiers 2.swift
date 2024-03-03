//
//  Custom View Modifiers.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI
import Combine

extension View {
 
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
    
    func styleOfBubblesInSettings() -> some View {
        return modifier(StyleOfBubblesInSettings())
    }
    
}


struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                    }
                    .map { rect in
                        rect.height - geometry.safeAreaInsets.bottom
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

struct RoomBubbleViewDeletion: ViewModifier {
    
    @Binding var isDeleting: Bool
    var atButtonPress: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            
            if isDeleting {
                Button {
                    atButtonPress()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxHeight: .infinity)
                        .frame(width: 75)
                        .background(Color.red.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
            }
        
            content
                .offset(x: isDeleting ? -85 : 0)
                .padding(.leading, isDeleting ? 85 : 0)
            
        }
        
        
    }
    
}

struct StyleOfBubblesInSettings: ViewModifier {
    
    func body(content: Content) -> some View {
        
        HStack {
            
            content
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }.padding(.horizontal, 15)
            .frame(height: 65)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}

struct ClientBubbleViewDeletion: ViewModifier {
    
    @Binding var isDeleting: Bool
    var atButtonPress: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            
            if isDeleting {
                Button {
                    atButtonPress()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxHeight: .infinity)
                        .frame(width: 80)
                        .background(Color.red.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
            }
            
            content
                .offset(x: isDeleting ? -90 : 0)
                .padding(.leading, isDeleting ? 90 : 0)
            
            
        }
        
    }
    
}
