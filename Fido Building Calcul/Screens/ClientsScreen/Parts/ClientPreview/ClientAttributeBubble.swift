//
//  ClientAttributeBubble.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ClientAttributeBubble: View {
    
    var title: LocalizedStringKey
    var value: String?
    var underline: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.brandBlack)
            
            Text(stringToShow(value: value))
                .font(.system(size: 19, weight: .semibold))
                .underline(underline)
                .textSelection(.enabled)
                .foregroundStyle(Color.brandBlack)
                .minimumScaleFactor(0.7)
            
        }
        
    }
    
    func stringToShow(value: String?) -> String {
        
        var stringToShow = "-"
        
        if let value {
            if !value.isEmpty {
                stringToShow = value
            }
        }
        
        return stringToShow
        
    }
    
}

struct ToggleableTitle: View {
    
    var title: LocalizedStringKey
    var toToggle: Bool = true
    var toShowChevron: Bool = true
    
    var body: some View {
    
        HStack {
            
            Text(title)
                .font(.system(size: toToggle ? 30 : 20, weight: toToggle ? .bold : .semibold))
                .fixedSize()
                .padding(.vertical, 5)
                .foregroundStyle(Color.brandBlack)
        
            Spacer()
            
            if toShowChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .rotationEffect(.degrees(toToggle ? 90 : 0))
                    .transition(.scale.combined(with: .move(edge: .leading).combined(with: .opacity)))
            }
            
        }

    }
    
}
