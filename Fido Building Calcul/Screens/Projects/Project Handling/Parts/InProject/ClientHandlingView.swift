//
//  ClientHandling.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/01/2024.
//

import SwiftUI

struct ClientHandlingView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behaviours: BehavioursViewModel
    @ObservedObject var viewModel: InProjectScreenViewModel
    var project: Project
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "person.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Client")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
                if project.toClient != nil {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            project.toClient = nil
                            try? viewContext.save()
                            behaviours.redraw()
                        }
                    } label: {
                        Image(systemName: "person.crop.circle.fill.badge.minus")
                            .font(.system(size: 24))
                            .foregroundColor(.brandBlack)
                    }
                }
                
            }
            
            if let client = project.toClient {
                Button { behaviours.projectsPath.append(client) } label: {
                    ClientBubble(client: client, isDeleting: viewModel.isDeletingClientConnection)
                    
                }
            } else {
                Button {
                    viewModel.isPickingClient = true
                } label: {
                    PickClientButton()
                }
            }
            
        }.redrawable()
    }
}

struct ClientBubble: View {
    
    var client: Client
    var isDeleting: Bool
    
    var body: some View {
        
        
            HStack {
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    Text(client.unwrappedName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    if !client.unwrappedStreet.isEmpty && !client.unwrappedCity.isEmpty {
                        Text("\(client.unwrappedCity), \(client.unwrappedStreet)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.8))
                    } else if !client.unwrappedCity.isEmpty {
                        Text(client.unwrappedCity)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.8))
                    } else if !client.unwrappedStreet.isEmpty {
                        Text(client.unwrappedStreet)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.8))
                    } else if !client.unwrappedCountry.isEmpty {
                        Text(client.unwrappedCountry)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.8))
                    }
                    
                }
                
                Spacer()
                
                if !isDeleting {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.brandBlack)
                }
                
            }.padding(.vertical, (!client.unwrappedStreet.isEmpty && !client.unwrappedCity.isEmpty) || !client.unwrappedCountry.isEmpty ? 15 : 20)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                        .background(Color.brandGray)
                        .clipShape(.rect(cornerRadius: 20, style: .continuous))
                }
    }
    
}
