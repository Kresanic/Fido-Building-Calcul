//
//  ClientsScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/08/2023.
//

import SwiftUI

enum ClientType: String, CaseIterable { case personal, corporation }

@MainActor final class ClientsScreenViewModel: ObservableObject {
    
    @State var isCreatingNewClient = false
    @State var searchText = ""
    @State var isSearching = false
    @State var isDeleting = false
    
}
