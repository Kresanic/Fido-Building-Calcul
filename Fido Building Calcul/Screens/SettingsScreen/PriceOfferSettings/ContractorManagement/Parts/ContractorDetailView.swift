//
//  ContractorDetailView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/02/2024.
//

import SwiftUI

struct ContractorDetailView: View {
    
    var contractor: Contractor
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @State private var isCreatingContractor = false
    @State var selectedDetent: PresentationDetent = .large
    @StateObject var viewModel = ContractorDetailViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                Text(contractor.name ?? "Contractor")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 15)
                
                if let contractor = viewModel.user {
                    VStack(alignment: .center, spacing: 10) {
                        
                        
                        if let imageData = contractor.logo, let logo =  UIImage(data: imageData)  {
                            
                            VStack(alignment: .center, spacing: 5) {
                                
                                ToggleableTitle(title: "Logo", toShowChevron: false)
                                
                                Image(uiImage: logo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200)
                                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(15)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: 24, style: .continuous))
                            
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ToggleableTitle(title: "Contact", toShowChevron: false)
                            
                            ClientAttributeBubble(title: "Name", value: contractor.name)
                            
                            ClientAttributeBubble(title: "Email", value: contractor.email)
                            
                            ClientAttributeBubble(title: "Phone number", value: contractor.phone)
                            
                            ClientAttributeBubble(title: "Web page", value: contractor.web)
                            
                            ClientAttributeBubble(title: "Contact person", value: contractor.contactPersonName)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ToggleableTitle(title: "Business information", toShowChevron: false)
                            
                            ClientAttributeBubble(title: "Business ID", value: contractor.businessID)
                            
                            ClientAttributeBubble(title: "Tax ID", value: contractor.taxID)
                            
                            ClientAttributeBubble(title: "VAT Registration Number", value: contractor.vatRegistrationNumber)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ToggleableTitle(title: "Location", toShowChevron: false)
                            
                            ClientAttributeBubble(title: "Street", value: contractor.street)
                            
                            ClientAttributeBubble(title: "Additional info", value: contractor.secondRowStreet)
                            
                            ClientAttributeBubble(title: "City", value: contractor.city)
                            
                            ClientAttributeBubble(title: "Postal code", value: contractor.postalCode)
                            
                            ClientAttributeBubble(title: "Country", value: contractor.country)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ToggleableTitle(title: "Banking and legal", toShowChevron: false)
                            
                            ClientAttributeBubble(title: "Bank Account Number", value: contractor.bankAccountNumber)
                            
                            ClientAttributeBubble(title: "Bank Code", value: contractor.swiftCode)
                            
                            ClientAttributeBubble(title: "Legal appendix", value: contractor.legalNotice)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        
                        if let signatureData = contractor.signature, let signature =  UIImage(data: signatureData)  {
                            
                            VStack(alignment: .center, spacing: 5) {
                                
                                ToggleableTitle(title: "Signature", toShowChevron: false)
                                
                                Image(uiImage: signature)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200)
                                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(15)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: 24, style: .continuous))
                            
                        }
                        
                        Button {
                            isCreatingContractor = true
                        } label: {
                            EditContractorButton().padding(.horizontal, 30)
                        }
                        
                        Button {
                            behaviourVM.showDialogWindow(using: .init(alertType: .warning, title: "Delete contractor?", subTitle: "Deleting this contractor profile will permanently delete all data about this contractor and all assigned projects.", action: {
                                if behaviourVM.activeContractor == contractor {
                                    behaviourVM.activeContractor = nil
                                }
                                viewModel.deleteContractor()
                                dismiss()
                            }))
                        } label: {
                            DeleteContractorButton().padding(.horizontal, 50)
                        }
                        
                    }
                    
                }
                
            }.padding(.bottom, 80).transition(.opacity)
                .frame(maxWidth: .infinity)
            
        }.scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.automatic)
            .padding(.horizontal, 15)
            .sheet(isPresented: $isCreatingContractor, content: {
                ContractorEditView(presentationDetents: $selectedDetent, contractor: viewModel.user)
                    .presentationCornerRadius(25)
                    .presentationDetents([.height(225), .large], selection: $selectedDetent)
                    .interactiveDismissDisabled(true)
                    .presentationBackground(.brandWhite)
                    .onDisappear { selectedDetent = .large; behaviourVM.redraw() }
            })
            .task {
                withAnimation {
                    viewModel.user = contractor
                }
            }
    }
    
}
