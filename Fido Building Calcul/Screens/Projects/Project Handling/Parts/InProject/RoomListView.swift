//
//  RoomListView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct RoomsList: View {
    
    var project: Project
    @ObservedObject var viewModel: InProjectScreenViewModel
    let scrollToPos: ScrollViewProxy
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest var fetchedRooms: FetchedResults<Room>
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    init(project: Project, viewModel: InProjectScreenViewModel, scrollToPos: ScrollViewProxy) {
        
        self.viewModel = viewModel
        
        self.project = project
        
        self.scrollToPos = scrollToPos
        
        let fetchRequest = Room.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.dateCreated, ascending: false)]
        
        fetchRequest.predicate = NSPredicate(format: "fromProject == %@", project)
        
        _fetchedRooms = FetchRequest(fetchRequest: fetchRequest)
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "square.split.bottomrightquarter.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Rooms")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
                if !viewModel.isCreatingNewRoom {
                    
                    Button {
                        viewModel.toggleIsDeleting()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.brandBlack)
                    }.padding(.trailing, 4)
                
                    Button {
                        viewModel.toggleIsCreatingRoom()
                        withAnimation { scrollToPos.scrollTo("RoomCreation", anchor: .top) }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.brandBlack)
                    }
                }
                
            }
            
            if viewModel.isCreatingNewRoom {
                NewRoomView(viewModel: viewModel, project: project)
                    .transition(.scale(scale: 0.0, anchor: .topTrailing))
                    .onAppear{ viewModel.isDeletingRooms = false }
            }
            
            if let priceList = fetchedPriceList.last {
                
                if fetchedRooms.isEmpty && !viewModel.isCreatingNewRoom {
                    Button {
                        viewModel.toggleIsCreatingRoom()
                    } label: {
                        CreateRoomBubble()
                    }
                } else {
                    ForEach(fetchedRooms) { room in
                        
                        Button { behaviours.projectsPath.append(room) } label: {
                            RoomBubbleView(room: room, priceList: priceList, isDeleting: viewModel.isDeletingRooms)
                                .redrawable()
                                .modifier(RoomBubbleViewDeletion(isDeleting: $viewModel.isDeletingRooms, atButtonPress: {
                                    withAnimation(.easeInOut) {
                                        viewContext.delete(room)
                                        try? viewContext.save()
                                    }
                                }))
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                    }
                }
            }
            
        }.navigationBarTitleDisplayMode(.inline)
        
    }
    
}
