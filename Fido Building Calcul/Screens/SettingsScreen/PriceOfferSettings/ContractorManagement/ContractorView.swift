//
//  ContractorView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ContractorView: View {
    
    @State private var isCreatingContractor = false
    @State var selectedDetent: PresentationDetent = .large
    @FetchRequest(entity: Contractor.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: false)]) var fetchedContractors: FetchedResults<Contractor>
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Contractors details")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
                if !fetchedContractors.isEmpty {
                    Button {
                        isCreatingContractor = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.brandBlack)
                    }
                }
                
            }
            
            ContractorsListView(isCreatingContractor: $isCreatingContractor)
            
        }.sheet(isPresented: $isCreatingContractor, content: {
            ContractorEditView(presentationDetents: $selectedDetent)
                .presentationCornerRadius(25)
                .presentationDetents([.height(225), .large], selection: $selectedDetent)
                .interactiveDismissDisabled(true)
                .presentationBackground(.brandWhite)
                .onDisappear { selectedDetent = .large }
        })
        
        
    }
    
}


