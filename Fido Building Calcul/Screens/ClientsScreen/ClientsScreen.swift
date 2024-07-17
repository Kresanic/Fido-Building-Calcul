//
//  ClientsScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/08/2023.
//

import SwiftUI

struct ClientsScreen: View {
    
    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)]) var clients: FetchedResults<Client>
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @State var isCreatingNewClient = false
    @State var searchText = ""
    @State var isDeleting = false
    @State var selectedDetent: PresentationDetent = .height(225)
    @State var isInteractiveDismissDisabled = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        NavigationStack(path: $behaviourVM.clientsPath) {
            
            ScrollView {
                
                VStack(spacing: 15) {
                    
                    // MARK: Title and Buttons
                    HStack(spacing: 8) {
                        
                        Text("Clients")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                        if !clients.isEmpty {
                            
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isDeleting.toggle() }
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }

                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { isCreatingNewClient = true }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.brandBlack)
                            }
                            
                        }
                        
                    }
                    
                    // MARK: SearchBar
                    TextField("Search", text: $searchText)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .focused($isFocused)
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
                .navigationBarTitleDisplayMode(.inline)
                .scrollDismissesKeyboard(.immediately)
                .onTapGesture { dismissKeyboard() }
                .sheet(isPresented: $isCreatingNewClient) {
                    CreateNewClientView(presentationDetents: $selectedDetent, isInteractiveDismissDisabled: $isInteractiveDismissDisabled)
                        .presentationDetents([.height(225), .large], selection: $selectedDetent)
                        .presentationCornerRadius(25)
                        .interactiveDismissDisabled(isInteractiveDismissDisabled)
                        .presentationDragIndicator(isInteractiveDismissDisabled ? .hidden : .visible)
                        .onDisappear {
                            selectedDetent = .height(225)
                            isInteractiveDismissDisabled = false
                        }
                }
                .onChange(of: searchText) { newValue in
                    withAnimation {
                        clients.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "name contains[cd] %@", newValue)
                    }
                }
                .navigationDestination(for: Client.self) { client in
                    ClientPreviewScreen(client: client)
                }
            
        }
        
    }
    
}
