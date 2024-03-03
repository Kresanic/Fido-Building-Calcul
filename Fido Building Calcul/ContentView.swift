//
//  ContentView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 26/07/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var contextOfPersistance
    
    
    var body: some View {
        
        VStack {
            Text("Works!")
                .font(.largeTitle)
        }
        
    }
 
}
