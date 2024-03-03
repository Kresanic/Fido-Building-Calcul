//
//  NewRoomView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct NewRoomView: View {
    
    @ObservedObject var viewModel: InProjectScreenViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @FocusState private var isFocused: Bool
    var project: Project
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Text("New room")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.brandBlack)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isCreatingNewRoom = false
                            viewModel.havingCustomName = false
                            viewModel.customRoomName = ""
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.brandBlack)
                            .padding(.all, 9)
                            .background(Color.brandGray)
                            .clipShape(Circle())
                            .padding(.trailing, 20)
                    }
                }.padding(.bottom, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .center) {
                ForEach(RoomTypes.allCases, id: \.self) { roomType in
                    Text(RoomTypes.readable(roomType))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.horizontal, 5)
                        .frame(width: 125)
                        .frame(height: 45)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                if roomType == .other {
                                    viewModel.havingCustomName = true
                                    isFocused = true
                                } else {
                                    if let newRoom = viewModel.createNewRoom(forProject: project, roomType: roomType) {
                                        dismissKeyboard()
                                        behaviourVM.switchToRoom(with: newRoom)
                                    }
                                }
                            }
                        }
                }
            }.padding(.bottom, 20).padding(.horizontal, 40)
            
            if viewModel.havingCustomName {
                
                TextField("Room name", text: $viewModel.customRoomName)
                    .labelsHidden()
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.brandBlack)
                    .focused($isFocused)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.brandWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal, 40)
                    .submitLabel(.done)
                    .onSubmit { if let newRoom = viewModel.createNewRoom(forProject: project, roomType: .other) {
                        dismissKeyboard()
                        behaviourVM.switchToRoom(with: newRoom)
                    } }
                    .padding(.bottom, 20)
                
                Button {
                    if let newRoom = viewModel.createNewRoom(forProject: project, roomType: .other) {
                        dismissKeyboard()
                        behaviourVM.switchToRoom(with: newRoom)
                    }
                } label: {
                    Text("Create!")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.brandWhite)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.brandBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    
                }
                
            }
            
        }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        
    }
    
}

struct CreateRoomBubble: View {
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text("Create room")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                Text("Add room to this project")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                
            }
            
            Spacer()
            
            Image(systemName: "plus")
                .font(.system(size: 24))
                .foregroundStyle(Color.brandBlack)
            
        }.padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}
