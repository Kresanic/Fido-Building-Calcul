//
//  ChoosingContractorView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 05/03/2024.
//

import SwiftUI

struct ChoosingContractorView: View {
    
    @Binding var contractor: Contractor?
    @FetchRequest(entity: Contractor.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: false)]) var fetchedContractors: FetchedResults<Contractor>
    @EnvironmentObject var behaviours: BehavioursViewModel
    @State var isCreatingContractor: Bool = false
    @State var selectedDetent: PresentationDetent = .large
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 15) {
                
                HStack(spacing: 8) {
                    
                    Text("Contractors")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(Color.brandBlack)
                    
                    Spacer()
                    
                    if !fetchedContractors.isEmpty {
                        
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isCreatingContractor = true }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 26))
                                .foregroundColor(.brandBlack)
                        }
                        
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 26))
                            .foregroundColor(.brandBlack)
                    }
                    
                }
                
                VStack {
                    if fetchedContractors.isEmpty {
                        Button { isCreatingContractor = true } label: {
                            CreateContractorButton()
                        }
                    } else {
                        ForEach(fetchedContractors) { contr in
                            Button {
                                withAnimation(.bouncy) {
                                    contractor = contr
                                    dismiss()
                                }
                            } label: {
                                ContractorBubble(contractor: contr, hasChevron: false)
                            }
                        }
                    }
                }
                
            }
            .padding(.horizontal, 15)
                .padding(.bottom, 105)
                .padding(.top, 15)
            
            .sheet(isPresented: $isCreatingContractor, content: {
                ContractorEditView(presentationDetents: $selectedDetent)
                    .presentationCornerRadius(25)
                    .presentationDetents([.height(225), .large], selection: $selectedDetent)
                    .interactiveDismissDisabled(true)
                    .presentationBackground(.brandWhite)
                    .onDisappear { selectedDetent = .large; behaviours.redraw() }
            })
            
        }.scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .background { Color.brandWhite.ignoresSafeArea() }
    }
    
}
