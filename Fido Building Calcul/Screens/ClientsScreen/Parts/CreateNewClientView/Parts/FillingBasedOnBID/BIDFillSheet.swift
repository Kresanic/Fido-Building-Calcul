//
//  BIDFillSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/12/2023.
//

import SwiftUI

struct BIDFillSheet: View {
    
    @ObservedObject var viewModel: CreateNewClientViewModel
    @Environment(\.dismiss) var dismiss
    @State var bid = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack {
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .foregroundStyle(Color.brandGray)
                    .frame(width: 30, height: 5)
                
                Spacer()
                
                Text("Data completion")
                    .foregroundStyle(Color.brandBlack)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                
                Text("Insert BID and we will search for it in database and fill all publicly available information about the company.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 30)
                
                
                TextField("12345679", text: $bid)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit { Task { viewModel.retrieveInformation(from: bid) } }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.brandWhite)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(viewModel.errorMessage != nil ? Color.brandRed : Color.brandGray, lineWidth: 2)
                    }
                    .padding(.horizontal, 20)
                
                if let messageNotice = viewModel.errorMessage {
                    Text(messageNotice)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.brandRed)
                        .multilineTextAlignment(.center)
                        .padding(.top, -3)
                        .padding(.horizontal, 20)
                }
                
                Button {
                    viewModel.retrieveInformation(from: bid)
                } label: {
                    if viewModel.isLookingForBID {
                        Text("Looking for company...")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color.brandGray)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color.brandDarkGray)
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    } else {
                        Text("Fill info")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color.brandWhite)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color.brandBlack)
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                    }
                }
                
                Spacer()
                
            }.padding(15)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .background {
                    Color.brandWhite.clipShape(.rect(cornerRadius: 40, style: .continuous))
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                        .onTapGesture { dismissKeyboard() }
                }
            
//            if #available(iOS 18.0, *), isFocused { Spacer(minLength: 225) }
            
        }  .presentationDetents([.height(315)])
            .presentationCornerRadius(0)
            .presentationBackground(.clear)
            .presentationBackgroundInteraction(.disabled)
            .onDisappear { viewModel.errorMessage = nil }
    }
    
}

