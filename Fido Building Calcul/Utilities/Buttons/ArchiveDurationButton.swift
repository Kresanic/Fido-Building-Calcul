//
//  ArchiveDurationButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ArchiveDurationButton: View {
    
    var timeToArchive: ArchiveForTime
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    
    var body: some View {
        
        Button {
            withAnimation { archiveForDays = timeToArchive.rawValue }
        } label: {
            Text(timeToArchive.rawValue >= 99999 ? "Forever" : "\(timeToArchive.rawValue) days")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(archiveForDays == timeToArchive.rawValue ? Color.brandWhite : Color.brandBlack)
                .minimumScaleFactor(0.7)
                .fixedSize()
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(archiveForDays == timeToArchive.rawValue ? Color.brandBlack : Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
    
}
