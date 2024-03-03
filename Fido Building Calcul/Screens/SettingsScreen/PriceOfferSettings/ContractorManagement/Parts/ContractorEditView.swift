//
//  ContractorEditView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 14/11/2023.
//

import SwiftUI

struct ContractorEditView: View {
    
    @StateObject var viewModel = ContractorViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var presentationDetents: PresentationDetent
    @State var isShowingLargeSheet = true
    var contractor: Contractor?
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                HStack {
                    
                    Button("Cancel") {
                        dismissKeyboard()
                        if viewModel.hasProgressBeenMade() {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                presentationDetents = .height(225)
                            }
                        } else {
                            dismiss()
                        }
                    }.frame(width: 75, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Edit contractor")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    
                Button("Save") {
                    dismissKeyboard()
                    if let _ = viewModel.createUser() {
                        dismiss()
                    }
                }.frame(width: 75, alignment: .trailing)
                    
                }.padding(.top, 25)
                    .padding(.horizontal, 25)
                    
                if !isShowingLargeSheet {
                    AttentionToDismissCreationOfClient(presentationDetents: $presentationDetents)
                } else {
                    ContractorEditDetailsView(viewModel: viewModel, contractor: contractor)
                }
                
            }
            
        }.scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.automatic)
            .frame(maxWidth: .infinity)
            .onAppear {
                withAnimation {
                    if let contractor {
                        viewModel.user = contractor
                    }
                }
            }
            .onChange(of: presentationDetents) { detent in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if detent == .large {
                        isShowingLargeSheet = true
                    } else {
                        isShowingLargeSheet = false
                        if !viewModel.hasProgressBeenMade() {
                            dismiss()
                        }
                    }
                }
            }
            .background{ Color.brandWhite.onTapGesture { dismissKeyboard() }.ignoresSafeArea() }
    }
    
}
