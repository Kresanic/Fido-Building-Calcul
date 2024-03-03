//
//  ArchiveDurationView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ArchiveDurationView: View {
    
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Archiving period")
                
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    
                    ForEach(ArchiveForTime.allCases, id: \.self) { forTime in
                        ArchiveDurationButton(timeToArchive: forTime)
                            .transition(.scale)
                        if forTime.rawValue < 9999 { Spacer() }
                    }
                    
                }
                
                if archiveForDays < 9999 {
                    Text("Your projects will remain in archive for \(archiveForDays) days, after that they will be deleted automatically.")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                } else {
                    Text("Your projects will remain in archive forever. They will not be deleted, unless you do so.")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                }
                
            }.padding(15)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
}
