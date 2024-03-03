//
//  InProjectChoosingClientViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/08/2023.
//

import SwiftUI

@MainActor final class InProjectChoosingClientViewModel: ObservableObject {
    
    @State var isCreatingNewClient = false
    @State var searchText = ""
    @State var isSearching = false
    
}
