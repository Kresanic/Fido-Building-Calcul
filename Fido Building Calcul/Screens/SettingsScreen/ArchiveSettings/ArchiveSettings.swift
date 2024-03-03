//
//  Archive.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ArchiveSettings: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Text("Archive")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .padding(.bottom, 15)
                
                ArchiveDurationView().padding(.bottom, 10)
                
                ArchivedProjectsView()
                
            }.padding(.horizontal, 15)
            
        }
    }
}
