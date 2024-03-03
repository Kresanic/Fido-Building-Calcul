//
//  CreateNewClientView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/08/2023.
//

import SwiftUI

struct CreateNewClientView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = CreateNewClientViewModel()
    @State var activeClientType: ClientType? = nil
    @Binding var presentationDetents: PresentationDetent
    @Binding var isInteractiveDismissDisabled: Bool
    @State var isShowingLargeSheet = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                
                HStack {
                    
                    Button("Zrušiť") {
                        if viewModel.hasProgressBeenMade() {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                presentationDetents = .height(225)
                            }
                        } else {
                            dismiss()
                        }
                    }.frame(width: 75, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Nový klient")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    if let activeClientType = activeClientType {
                        Button("Uložiť") {
                            if let createdClient = viewModel.createNewClient(clientType: activeClientType) {
                                dismiss()
                            }
                        }.frame(width: 75, alignment: .trailing)
                    } else { Rectangle().frame(width: 75, height: 0, alignment: .trailing) }
                    
                }.padding(.top, 25)
                    .padding(.horizontal, 25)
                
                if activeClientType == nil {
                    ClientTypeSelector(activeClientType: $activeClientType)
                } else {
                    if !isShowingLargeSheet {
                        AttentionToDismissCreationOfClient(presentationDetents: $presentationDetents)
                    }
                }

                if activeClientType == .personal && presentationDetents == .large {
                    PersonalClientCreationView(viewModel: viewModel)
                        .transition(.opacity)
                } else if activeClientType == .corporation && presentationDetents == .large {
                    CorporationClientCreationView(viewModel: viewModel)
                        .transition(.opacity)
                }
                
            }
        }.scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.automatic)
            .frame(maxWidth: .infinity)
            .onChange(of: activeClientType) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    presentationDetents = .large
                    isInteractiveDismissDisabled = true
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
        .background{ Color.brandWhite.onTapGesture { dismissKeyboard() } }
            
        
    }
    
}
