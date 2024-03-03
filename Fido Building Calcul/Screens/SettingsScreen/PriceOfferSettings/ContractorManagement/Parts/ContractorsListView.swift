//
//  ContractorsListView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI

struct ContractorsListView: View {
    
    @FetchRequest(entity: Contractor.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: false)]) var fetchedContractors: FetchedResults<Contractor>
    @EnvironmentObject var behaviours: BehavioursViewModel
    @Binding var isCreatingContractor: Bool
    
    var body: some View {
       
        VStack {
            if fetchedContractors.isEmpty {
                Button { isCreatingContractor = true } label: {
                    CreateContractorButton()
                }
            } else {
                ForEach(fetchedContractors) { contractor in
                    NavigationLink(value: contractor) {
                        ContractorBubble(contractor: contractor)
                    }
                }
            }
            
        }.redrawable()
                
    }
    
}
