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
    @State var isShowingCalculationBill = false
    @Environment(\.managedObjectContext) var viewContext
    
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
                
                ScrollViewReader { scrollProxy in
                
                VStack {
                    
                    HStack(alignment: .center) {
                        
                        TextField("Room name", text: $viewModel.roomName, onCommit: {
                            viewModel.saveRoomName(room: fetchedRoom)
                        })
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(Color.brandBlack)
                        .lineLimit(1)
                        .submitLabel(.done)
                        .onSubmit { viewModel.saveAll() }
                        
                        Spacer()
                        
                    }.onAppear { viewModel.roomLoading(room: fetchedRoom) }
                    
                    HStack(alignment: .center) {
                        
                        Image(systemName: "hammer.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Text("Work")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                    }.padding(.top, 10)
                    
                    VStack {
                        
                        DemolitionBubble(room: fetchedRoom, scrollProxy: scrollProxy).id(Demolition.scrollID)
                        
                        WiringViews(room: fetchedRoom, scrollProxy: scrollProxy).id(Wiring.scrollID)
                        
                        PlumbingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(Plumbing.scrollID)
                        
                        BrickLayingOfPartitionsViews(room: fetchedRoom, scrollProxy: scrollProxy).id(BrickPartition.scrollID)
                        
                        BrickLoadBearingWallViews(room: fetchedRoom, scrollProxy: scrollProxy).id(BrickLoadBearingWall.scrollID)
                        
                        PlasterboardingPartitionViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PlasterboardingPartition.scrollID)
                        
                        PlasterboardingOffsetWallViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PlasterboardingOffsetWall.scrollID)
                        
                        PlasterBoardCeilingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PlasterboardingCeiling.scrollID)
                        
                        NettingWallViews(room: fetchedRoom, scrollProxy: scrollProxy).id(NettingWall.scrollID)
                        
                        NettingCeilingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(NettingCeiling.scrollID)
                    }
                    
                    VStack {
                        
                        PlasteringWallViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PlasteringWall.scrollID)
                        
                        PlasteringCeilingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PlasteringCeiling.scrollID)
                        
                        FacadePlasteringViews(room: fetchedRoom, scrollProxy: scrollProxy).id(FacadePlastering.scrollID)
                        
                        InstallationOfCornerBeadViews(room: fetchedRoom, scrollProxy: scrollProxy).id(InstallationOfCornerBead.scrollID)
                        
                        PlasteringOfWindowSashViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PlasteringOfWindowSash.scrollID)
                        
                        PenetrationCoatingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PenetrationCoating.scrollID)
                        
                        PaintingWallViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PaintingWall.scrollID)
                        
                        PaintingCeilingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PaintingCeiling.scrollID)
                        
                        LevellingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(Levelling.scrollID)
                        
                        FloatingFLoorLayingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(LayingFloatingFloors.scrollID)
                        
                        TileCeramicViews(room: fetchedRoom, scrollProxy: scrollProxy).id(TileCeramic.scrollID)
                        
                    }
                    
                    VStack {
                        
                        PavingCeramicViews(room: fetchedRoom, scrollProxy: scrollProxy).id(PavingCeramic.scrollID)
                        
                        GroutingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(Grouting.scrollID)
                        
                        SiliconingViews(room: fetchedRoom, scrollProxy: scrollProxy).id(Siliconing.scrollID)
                        
                        InstallationOfSanitaryViews(room: fetchedRoom, scrollProxy: scrollProxy).id(InstallationOfSanitary.generalTitle.stringKey)
                        
                        WindowInstallationsViews(room: fetchedRoom, scrollProxy: scrollProxy).id(WindowInstallation.scrollID)
                        
                        InstallationOfDoorJambViews(room: fetchedRoom, scrollProxy: scrollProxy).id(InstallationOfDoorJamb.scrollID)
                        
                    }
                    
                    VStack {
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "box.truck.badge.clock.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Others")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 10)
                        
                        CustomWorksAndMaterialsViews(room: fetchedRoom, scrollProxy: scrollProxy).id(CustomWork.scrollID)
                        
                        CommuteExpensesViews(room: fetchedRoom, scrollProxy: scrollProxy).id(Commute.scrollID)
                        
                        RentalViews(room: fetchedRoom, scrollProxy: scrollProxy).id(ToolRental.scrollID)
                        
                    }
                    
                    RoomCalculationBill(room: fetchedRoom, isShowing: $isShowingCalculationBill)
                        
                }
                .padding(.bottom, 105)
                    
                }
                
            }.padding(.horizontal, 15)
                .scrollIndicators(.never)
                .scrollDismissesKeyboard(.interactively)
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    Color.brandWhite.opacity(0)
                        .onTapGesture {
                            viewModel.saveAll()
                            dismissKeyboard()
                        }
                }
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut) { isShowingCalculationBill = true }
                    }
                }
            
        } else { EmptyView().onAppear { dismiss() } }
        
    }
}
