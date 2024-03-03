//
//  InProjectContractor.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI

struct InProjectContractor: View {
    
    var project: Project
    @State var isChoosingContractor = false
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    var body: some View {
        
        VStack {
            Button {
                isChoosingContractor = true
            } label: {
                if let contractor = project.contractor {
                    InProjectContractorBubble(contractor: contractor)
                } else {
                    InProjectNoContractorBubble()
                }
            }
            
        }.redrawable()
        .sheet(isPresented: $isChoosingContractor) {
            InProjectChoosingContractorView(project: project)
                .presentationDetents([.large])
                .presentationCornerRadius(25)
                .onDisappear{ behaviours.redraw() }
        }
        
    }
    
}
