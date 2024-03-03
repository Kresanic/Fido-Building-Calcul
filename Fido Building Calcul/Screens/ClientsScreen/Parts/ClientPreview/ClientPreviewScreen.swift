//
//  ClientPreviewScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/09/2023.
//

import SwiftUI

struct ClientPreviewScreen: View {
    
    @FetchRequest var fetchedClient: FetchedResults<Client>
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @State private var isEditingClient = false
    @State var selectedDetent: PresentationDetent = .large
    @State var isCreatingAssignedProject = false
    @State var isShowingContact = false
    @State var isShowingBusinessInfo = false
    @State var isShowingLocation = false
    
    init(client: Client) {
        
        let request = Client.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.dateCreated, ascending: false)]
        
        let clientID = client.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "cId == %@", clientID as CVarArg)
        
        _fetchedClient = FetchRequest(fetchRequest: request)
        
    }
    
    
    var body: some View {
        
        if let client = fetchedClient.first {
            ScrollView {
                
                VStack(alignment: .center, spacing: 10) {
                    
                    VStack(alignment: .center, spacing: 5) {
                        
                        Image(systemName: client.type == ClientType.personal.rawValue ? "person.circle.fill" : "building.columns.circle.fill")
                            .font(.system(size: 130))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(client.unwrappedName)
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(Color.brandBlack)
                        
                    }.padding(.bottom, 10)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                ToggleableTitle(title: "Contact", toToggle: isShowingContact)
                                
                                if isShowingContact {
                                    
                                    ClientAttributeBubble(title: "Name", value: client.name)
                                    
                                    ClientAttributeBubble(title: "Email", value: client.email, underline: true)
                                        .onTapGesture {
                                            if let clientMail = client.email {
                                                let tel = "mailto:"
                                                let formattedString = tel + clientMail
                                                guard let url = URL(string: formattedString) else { return }
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                    
                                    ClientAttributeBubble(title: "Phone number", value: client.phone, underline: true)
                                        .onTapGesture {
                                            if let clientPhone = client.phone {
                                                let tel = "tel://"
                                                let formattedString = tel + clientPhone
                                                guard let url = URL(string: formattedString) else { return }
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                
                                    if client.type == ClientType.corporation.rawValue {
                                        ClientAttributeBubble(title: "Contact person", value: client.contactPersonName)
                                    }
                                    
                                }
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(15)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: isShowingContact ? 24 : 20, style: .continuous))
                                .onTapGesture { withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowingContact.toggle() } }
                        
                            if client.type == ClientType.corporation.rawValue {
                                
                            VStack(alignment: .leading, spacing: 10) {
                                
                                ToggleableTitle(title: "Business information", toToggle: isShowingBusinessInfo)
                                
                                if isShowingBusinessInfo {
                                
                                    ClientAttributeBubble(title: "Business ID", value: client.businessID)
                                    
                                    ClientAttributeBubble(title: "Tax ID", value: client.taxID)
                                    
                                    ClientAttributeBubble(title: "VAT Registration Number", value: client.vatRegistrationNumber)
                                    
                                }
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(15)
                                .background(Color.brandGray)
                                .clipShape(.rect(cornerRadius: isShowingBusinessInfo ? 24 : 20, style: .continuous))
                                .onTapGesture { withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowingBusinessInfo.toggle() } }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ToggleableTitle(title: "Location", toToggle: isShowingLocation)
                            
                            if isShowingLocation {
                                
                                ClientAttributeBubble(title: "Street", value: client.street)
                                
                                ClientAttributeBubble(title: "Additional info", value: client.secondRowStreet)
                                
                                ClientAttributeBubble(title: "City", value: client.city)
                                
                                ClientAttributeBubble(title: "Postal code", value: client.postalCode)
                                
                                ClientAttributeBubble(title: "Country", value: client.country)
                                
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(15)
                            .background(Color.brandGray)
                            .clipShape(.rect(cornerRadius: isShowingLocation ? 24 : 20, style: .continuous))
                            .onTapGesture { withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isShowingLocation.toggle() } }
                            .padding(.bottom, 10)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            HStack {
                                
                                Text("Client's projects")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                if !client.associatedProjects.isEmpty {
                                    Button { isCreatingAssignedProject = true } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color.brandBlack)
                                    }
                                    
                                }
                                
                            }
                            
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    if !client.associatedProjects.isEmpty {
                                    ForEach(client.associatedProjects) { assProject in
                                        
                                        Button {
                                            behaviourVM.switchToProjectsPage(with: assProject)
                                        } label: {
                                            ClientsProjectBubble(project: assProject)
                                        }
                                        
                                    }
                                        
                                    } else {
                                        
                                        Button { isCreatingAssignedProject = true } label: {
                                            HStack {
                                                Text("Create project for client")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundStyle(Color.brandBlack)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "plus")
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(Color.brandBlack)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 20)
                                            .background(Color.brandWhite)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        }
                                        
                                    }
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(15)
                                    .background(Color.brandGray)
                                    .clipShape(.rect(cornerRadius: 24, style: .continuous))
                                
                    }
                    
                    Button {
                        isEditingClient = true
                    } label: {
                        EditClientButton()
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 80)
                
            }.sheet(isPresented: $isEditingClient) {
                ClientEditView(client: client, presentationDetents: $selectedDetent)
                    .presentationDetents([.height(225), .large], selection: $selectedDetent)
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
                    .presentationDragIndicator(.hidden)
                    .onDisappear { selectedDetent = .large }
            }
            .sheet(isPresented: $isCreatingAssignedProject) {
                NewClientsProjectSheet(toClient: client)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(25)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
}
