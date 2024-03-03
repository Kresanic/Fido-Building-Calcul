//
//  RoomScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//

import SwiftUI
import CoreData

struct RoomScreen: View {
    
    @FetchRequest var fetchedRooms: FetchedResults<Room>
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = RoomScreenViewModel()
    
    init(room: Room) {
        
        let roomRequest = Room.fetchRequest()
        
        roomRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: true)]
        
        let cUUID = room.cId ?? UUID()
        
        roomRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedRooms = FetchRequest(fetchRequest: roomRequest)
        
    }
    
    var body: some View {
        
        if let fetchedRoom = fetchedRooms.first {
            
            ScrollView {
                
                VStack {
                    
                    HStack {
                        
                        TextField("Názov Miestnosti", text: $viewModel.roomName, onCommit: {
                            viewModel.saveRoomName(room: fetchedRoom)
                        })
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(Color.brandBlack)
                        .lineLimit(1)
                        .submitLabel(.done)
                        .onSubmit { viewModel.saveAll() }
                        
                        Spacer()
                        
                    }.padding(.top, 15)
                        .onAppear { viewModel.roomLoading(room: fetchedRoom) }
                    
                    HStack(alignment: .center) {
                        
                        Image(systemName: "hammer.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Text("Práca")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                    }.padding(.top, 10)
                    
                    VStack {
                        DemolitionWorkBubble(room: fetchedRoom)
                        
                        ElectricalInstallationWorkViews(room: fetchedRoom)
                        
                        PlumbingWorkViews(room: fetchedRoom)
                        
                        BrickLayingOfPartitionsViews(room: fetchedRoom)
                        
                        BrickLayingOfLoadBearingWallViews(room: fetchedRoom)
                        
                        PlasterboardPartitionViews(room: fetchedRoom)
                        
                        PlasterBoardCeilingViews(room: fetchedRoom)
                        
                        NettingWallViews(room: fetchedRoom)
                        
                        NettingCeilingViews(room: fetchedRoom)
                    }
                    VStack {
                        
                        PlasteringWallViews(room: fetchedRoom)
                        
                        PlasteringCeilingViews(room: fetchedRoom)
                        
                        InstallationOfCornerStripViews(room: fetchedRoom)
                        
                        PlasteringOfRevealViews(room: fetchedRoom)
                        
                        PenetrationCoatViews(room: fetchedRoom)
                        
                        PaintingWallViews(room: fetchedRoom)
                        
                        PaintingCeilingViews(room: fetchedRoom)
                        
                        LevellingViews(room: fetchedRoom)
                        
                        FloatingFLoorLayingViews(room: fetchedRoom)
                        
                        TileCeramicViews(room: fetchedRoom)
                    }
                    VStack {
                        PavingCeramicViews(room: fetchedRoom)
                        
                        GroutingTilesAndPavingViews(room: fetchedRoom)
                        
                        SiliconizationViews(room: fetchedRoom)
                        
                        InstallationOfSanitaryWareViews(room: fetchedRoom)
                        
                        WindowInstallationsViews(room: fetchedRoom)
                        
                        InstallationOfLinedDoorFrameViews(room: fetchedRoom)
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "box.truck.badge.clock.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Pohonné hmoty")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 10)
                        
                        CommuteLengthViews(room: fetchedRoom)
                        
                        DaysInWorkViews(room: fetchedRoom)
                        
                    }
                    
                    RoomCalculationBill(room: fetchedRoom)
                }
                
            }.padding(.horizontal, 15)
                .scrollIndicators(.never)
                .scrollDismissesKeyboard(.interactively)
                .background {
                    Color.brandWhite
                        .onTapGesture {
                            viewModel.saveAll()
                            dismissKeyboard()
                        }
                }
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification), perform: { obj in
                    if let textField = obj.object as? UITextField {
                        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                    }
                })
            
        } else { EmptyView().onAppear { dismiss() } }
        
    }
}
