//
//  SettingsScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/08/2023.
//

import SwiftUI

@MainActor final class SettingsScreenViewModel: ObservableObject {
    
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    
    func daysBetween(project: Project) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: project.archivedDate ?? Date.now, to: Date.now)
        return components.day ?? 0
    }
    
    
}
