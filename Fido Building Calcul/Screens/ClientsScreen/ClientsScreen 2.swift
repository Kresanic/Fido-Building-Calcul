//
//  ClientsScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/08/2023.
//

import SwiftUI

enum ClientType: String, CaseIterable { case personal, corporation }

struct ClientsScreen: View {
    
    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.dateCreated, ascending: false)]) var clients: FetchedResults<Client>
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @State var isCreatingNewClient = false
    @State var searchText = ""
    @State var isSearching = false
    @State var isDeleting = false
    @State var selectedDetent: PresentationDetent = .height(225)
    @State var isInteractiveDismissDisabled = false
    
    var body: some View {
        
        NavigationStack(path: $behaviourVM.clientsPath) {
            
            ScrollView {
                
                VStack(spacing: 15) {
                    
                    // MARK: Title and Buttons
                    HStack(spacing: 8) {
                        
                        Text("Klienti")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                        if !clients.isEmpty {
                            
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) { isDeleting.toggle() }
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }
                            
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                                    isSearching.toggle()
                                    searchText = ""
                                    dismissKeyboard()
                                }
                            } label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }

                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) { isCreatingNewClient = true }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }
                            
                        }
                        
                    }
                    
                    // MARK: SearchBar
                    if isSearching {
                        TextField("Hľadať", text: $searchText)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .overlay(alignment: .trailing) {
                                if !searchText.isEmpty {
                                    Button {
                                        withAnimation { searchText = "" }
                                    } label: {
                                        Image(systemName: "x.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color.brandWhite)
                                            .padding(.trailing, 12)
                                    }
                                }
                            }
                    }
                    
                    // MARK: List of Clients
                    if clients.isEmpty {
                        NoClientBubbleView(isCreatingNewClient: $isCreatingNewClient).padding(.top, 100)
                    } else {
                        VStack {
                            ForEach(clients) { client in
                                NavigationLink(value: client) {
                                    ClientBubbleView(client: client, isDeleting: isDeleting)
                                        .modifier(ClientBubbleViewDeletion(isDeleting: $isDeleting, atButtonPress: {
                                            withAnimation(.easeInOut) {
                                                viewContext.delete(client)
                                                try? viewContext.save()
                                            }
                                        }))
                                        
                                }.transition(
                                    .asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            }
                        }
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                    .padding(.top, 15)
                
            }.scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .onTapGesture { dismissKeyboard() }
                .sheet(isPresented: $isCreatingNewClient) {
                    if #available(iOS 16.4, *) {
                        CreateNewClientView(presentationDetents: $selectedDetent, isInteractiveDismissDisabled: $isInteractiveDismissDisabled)
                            .presentationDetents([.height(225), .large], selection: $selectedDetent)
                            .presentationCornerRadius(25)
                            .interactiveDismissDisabled(isInteractiveDismissDisabled)
                            .presentationDragIndicator(isInteractiveDismissDisabled ? .hidden : .visible)
                            .onDisappear {
                                selectedDetent = .height(225)
                                isInteractiveDismissDisabled = false
                            }
                    } else {
                        CreateNewClientView(presentationDetents: $selectedDetent, isInteractiveDismissDisabled: $isInteractiveDismissDisabled)
                            .presentationDetents([.height(225), .large], selection: $selectedDetent)
                            .interactiveDismissDisabled(isInteractiveDismissDisabled)
                            .presentationDragIndicator(isInteractiveDismissDisabled ? .hidden : .visible)
                            .onDisappear {
                                selectedDetent = .height(225)
                                isInteractiveDismissDisabled = false
                            }
                    }
                }
                .onChange(of: searchText) { newValue in
                    withAnimation {
                        clients.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "name CONTAINS %@", newValue)
                    }
                }
                .navigationDestination(for: Client.self) { client in
                    ClientPreviewScreen(client: client)
                }
            
        }
        
    }
    
}


