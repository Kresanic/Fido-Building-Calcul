//
//  ClientHandling.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct ClientBubbleView: View {
    
    var isDeleting: Bool
    var isGrayBackground: Bool = true
    @FetchRequest var fetchedClient: FetchedResults<Client>
    
    init(client: Client, isDeleting: Bool, isGrayBackground: Bool = true) {
        
        self.isDeleting = isDeleting
        
        self.isGrayBackground = isGrayBackground
        
        let request = Client.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.dateCreated, ascending: false)]
        
        let clientcId = client.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "cId == %@", clientcId as CVarArg)
        
        _fetchedClient = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        
        if let client = fetchedClient.first {
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
                .background(isGrayBackground ? Color.brandGray : Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
}

struct NoClientBubbleView: View {
    
    @Binding var isCreatingNewClient: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Spacer()
            
            Image(systemName: "person.text.rectangle.fill")
                .font(.system(size: 80, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
            Text("Add Client")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
            
            Text("Fill in your client and then assign a project to them")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.brandBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            Button {
                isCreatingNewClient = true
            } label: {
                Text("Create")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding(.top, 25)
            }
            
            Spacer()
        
        }.padding(.vertical, 25)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .padding(.horizontal, 15)
        
    }
    
}

struct InProjectClientBubbleView: View {
    
    var client: Client
    
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
            
        }.padding(.vertical, client.street != "" && client.city != "" ? 15 : 20)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
}

struct ClientTypeSelector: View {
    
    @Binding var activeClientType: ClientType?
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            
            Text("Type of client?")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            
            
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            activeClientType = .personal
                        }
                    } label: {
                        Text("Private")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: 140, height: 50)
                            .background(Color.brandWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            activeClientType = .corporation
                        }
                    } label: {
                        Text("Business")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: 140, height: 50)
                            .background(Color.brandWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
            }

            Spacer()
            
        }.frame(maxWidth: .infinity)
            .background(Color.brandGray)
            .clipShape(.rect(cornerRadius: 24, style: .continuous))
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 10)
        
    }
    
}

struct AttentionToDismissCreationOfClient: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var presentationDetents: PresentationDetent
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Text("Do you want to discard the changes?")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
            
            GeometryReader { mainGeo in
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            dismiss()
                        }
                    } label: {
                        Text("Yes")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .frame(width: mainGeo.size.width * 0.4, height: 50)
                            .background(Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            presentationDetents = .large
                        }
                    } label: {
                        Text("No")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.brandWhite)
                            .frame(width: mainGeo.size.width * 0.4, height: 50)
                            .background(Color.brandBlack)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    
                    Spacer()
                    
                }
            }

            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 10)
        
    }
    
}
