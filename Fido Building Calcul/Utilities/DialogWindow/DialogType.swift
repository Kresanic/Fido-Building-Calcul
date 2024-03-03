//
//  DialogType.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct Dialog: Identifiable {
    
    let id = UUID()
    let alertType: DialogAlertType
    let title: LocalizedStringKey
    let subTitle: LocalizedStringKey
    let action: () -> Void
    
}
