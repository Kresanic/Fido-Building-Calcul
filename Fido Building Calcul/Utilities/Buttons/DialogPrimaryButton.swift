//
//  DialogPrimaryButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct DialogPrimaryButton: View {
    
    var title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(Color.brandWhite)
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
            .frame(width: 125)
            .background(Color.brandBlack)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
    }
    
}
