//
//  OfferingBubble.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/10/2023.
//

import SwiftUI
import RevenueCat

struct LoadingBubble: View {
    
    var body: some View {
        
        ProgressView()
            .progressViewStyle(.circular)
            .foregroundColor(.brandBlack)
            .frame(width: 45, height: 45)
            .background(Color.brandDarkGray)
            .clipShape(Circle())
            
    }
    
}

struct OfferingBubble: View {
    
    var isSelected: Bool
    var package: Package
    
    var body: some View {
        
        HStack(spacing: 10) {
            
            CheckedCircle(isSelected: isSelected)
                .transition(.scale.combined(with: .opacity))
            
            
            VStack(alignment: .leading, spacing: 5) {
                
                HStack {
                    
                    Text(package.storeProduct.price, format: .currency(code: package.storeProduct.currencyCode ?? "EUR"))
                        .font(.system(size: 24, weight: .semibold))
                    +
                    Text(package.storeProduct.subscriptionPeriod?.unit == .year ? " / year" : " / month")
                        .font(.system(size: 24, weight: .semibold))
                        
                    Spacer()
                    
                }
                
                if package.storeProduct.subscriptionPeriod?.unit == .year {
                    Text("7 days of free trial, billed annually")
                        .font(.system(size: 11, weight: .medium))
                        .minimumScaleFactor(0.8)
                } else {
                    Text("7 days of free trial, billed monthly")
                        .font(.system(size: 11, weight: .medium))
                        .minimumScaleFactor(0.8)
                }
                
            }
            
        }.foregroundStyle(Color.brandBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.leading, 5)
            .frame(height: 100)
            .background(isSelected ? Color.brandWhite : Color.clear)
            .cornerRadius(30)
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.brandWhite, lineWidth: 4)
            }
            
    }
    
}

struct OfferingBubblePreview: View {
    
    @State private var rectScale: Double = 1.0
    
    var body: some View {
        
        HStack(spacing: 10) {
            
            CheckedCircle(isSelected: false)
                .transition(.scale.combined(with: .opacity))
            
            VStack(alignment: .leading, spacing: 5) {
                
                HStack {
                    
                    Text("€5.49 / Monthly")
                        .font(.system(size: 24, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: true, vertical: true)
                        .redacted(reason: .placeholder)
                    
                    Spacer()
                    
                }
                
                Text("7 days of free trial")
                    .font(.system(size: 11, weight: .medium))
                    .redacted(reason: .placeholder)
                
            }
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .frame(height: 100)
            .background(Color.clear)
            .cornerRadius(30)
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.brandWhite, lineWidth: 4)
            }
            .scaleEffect(rectScale)
            .task {
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
                    DispatchQueue.main.async {
                        switch rectScale {
                        case 1.0:
                            withAnimation(.easeInOut(duration: 0.7)) {
                                rectScale = 0.97
                            }
                        case 0.97:
                            withAnimation(.easeInOut(duration: 0.7)) {
                                rectScale = 1.0
                            }
                        default:
                            withAnimation(.easeInOut(duration: 0.5)) {
                                rectScale = 1.0
                            }
                        }
                    }
                }
            }
           
    }
    
}

struct CheckedCircle: View {
    
    var isSelected: Bool
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .foregroundColor(isSelected ? Color.brandBlack : Color.clear)
                .overlay {
                    Circle()
                        .strokeBorder(isSelected ? Color.clear : Color.brandWhite, lineWidth: 3)
                }
                
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.brandWhite)
            }
                
            
        }.frame(width: 40, height: 40)
        
        
    }
    
}

