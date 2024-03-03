//
//  InProjectScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/07/2023.
//

import SwiftUI

struct InProjectScreen: View {
    
    var project: Project
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = InProjectScreenViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    TitleAndNotesView(viewModel: viewModel, project: project)
                    
                    //InputCommuteAndDaysInWork(project: project, viewModel: viewModel)
                    
                    NavigationLink {
                        Text("Janko Hraško")
                    } label: {
                        ContactBubbleView()
                    }
                    
                    TotalPriceOffer(project: project)
                    
                    RoomsList(project: project, viewModel: viewModel)
                    
                    NavigationLink {
                        Text("Cenník")
                    } label: {
                        CustomPricesScreen()
                    }
                    
                    if project.isArchived {
                        ProjectIsArchivedButton(viewModel: viewModel, project: project)
                    } else {
                        Button {
                            if viewModel.tappedArchiveButton {
                                viewModel.archiveProject(project: project)
                                dismiss()
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                                    viewModel.tappedArchiveButton.toggle()
                                }
                            }
                        } label: { ArchiveButton(viewModel: viewModel) }
                    }
                }.padding(.horizontal, 15)
                    .padding(.bottom, 20)
                
            }.background(Color.brandGray)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
                        viewModel.saveEntireProject(project: project)
                        viewModel.tappedArchiveButton = false
                        viewModel.isDeletingRooms = false
                        dismissKeyboard()
                    }
                }
                .scrollDismissesKeyboard(.automatic)
                .onAppear { viewModel.projectLoading(project: project) }
                .navigationBarHidden(true)
            
        }
        
    }
    
}

struct InputNotes: View {
    
    var project: Project
    @ObservedObject var viewModel: InProjectScreenViewModel
    
    var body: some View {
        
        TextField("Poznámky", text: $viewModel.projectNotes, axis: .vertical)
            .font(.system(size: 17))
            .multilineTextAlignment(.leading)
            .lineLimit(4)
            .onChange(of: viewModel.projectNotes, perform: { newValue in
                viewModel.saveProjectNotes(project: project)
            })
            .frame(maxWidth: .infinity)
            .submitLabel(.done)
        
    }
    
}

struct ProjectIsArchivedButton: View {
    
    @ObservedObject var viewModel: InProjectScreenViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    var project: Project
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "tray.2.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Stav projektu")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            HStack {
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Archivovaný")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    if viewModel.archiveForDays > 90 {
                        Text(project.numberOfRooms == 1 ? "\(project.numberOfRooms) miestnosť" : "\(project.numberOfRooms) miestnost\(project.numberOfRooms < 0 ? "i" : "i")")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .transition(.opacity)
                    } else {
                        Text("\(viewModel.archiveForDays - viewModel.daysBetween(project: project)) dní do vymazania")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                            .transition(.opacity)
                    }
                    
                }
                
                Spacer()
                
                
                Button {
                    withAnimation(.easeInOut) {
                        project.isArchived = false
                        try? viewContext.save()
                        dismiss()
                    }
                } label: {
                    Image(systemName: "tray.and.arrow.up.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.horizontal, 10)
                }
            } .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }
    
}

//struct InputCommuteAndDaysInWork: View {
//
//    var project: Project
//    @ObservedObject var viewModel: InProjectScreenViewModel
//
//    var body: some View {
//
//        VStack(spacing: 8) {
//
//            HStack(alignment: .center) {
//
//                Image(systemName: "box.truck.badge.clock.fill")
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(Color.brandBlack)
//
//                Text("Celkom")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(Color.brandBlack)
//
//                Spacer()
//
//            }
//
//            VStack {
//
//                GeneralSmallInputBox(title: "Dĺžka práce", value: $viewModel.projectDaysInWork, unit: .day, isBackgroundWhite: true)
//
//                GeneralSmallInputBox(title: "Dĺžka cesty", value: $viewModel.projectCommuteLength, unit: .kilometer, isBackgroundWhite: true)
//
//                GeneralSmallInputBox(title: "Požičovňa náradia", value: $viewModel.projectToolRental, unit: .hour, isBackgroundWhite: true)
//
//                RoundedRectangle(cornerRadius: 5)
//                    .foregroundStyle(Color.brandGray)
//                    .frame(height: 2)
//
//                MinorPriceItem(itemName: "Cesta", price: viewModel.commutePrices(project: project))
//
//                MinorPriceItem(itemName: "Požičovňa náradia", price: viewModel.toolRentalPrices(project: project))
//
//                HStack(alignment: .firstTextBaseline) {
//
//                    Text("PHM a Náradie")
//                        .font(.system(size: 23, weight: .semibold))
//                        .foregroundStyle(Color.brandBlack)
//
//                    Spacer()
//
//                    VStack(alignment: .trailing, spacing: 0) {
//                        Text(viewModel.totalPriceForCommuteAndTools(project: project), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
//                            .font(.system(size: 23, weight: .semibold))
//                            .foregroundStyle(Color.brandBlack)
//
//                        Text("vrátane 20% DPH")
//                            .font(.system(size: 8))
//                            .foregroundStyle(Color.brandBlack)
//                    }
//
//
//                }
//
//
//            }.padding(.top, 20)
//                .padding(.bottom, 10)
//                .padding(.horizontal, 20)
//                .frame(maxWidth: .infinity)
//                .background(Color.brandWhite)
//                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//
//        }
//
//    }
//
//}

struct ContactBubbleView: View {
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "person.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Zákazník")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            HStack {
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    Text("Janko Hraško")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Text("Šafáríková 8, Prešov")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                    
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
                
            }.padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        
    }
    
}


struct TotalPriceOffer: View {
    
    var project: Project
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "list.bullet.rectangle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Celková cenová ponuka")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(.brandWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 250)
            
        }
        
    }
    
}

struct CustomPricesScreen: View {
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "eurosign.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Cenník projektu")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
            }
            
            HStack {
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    Text("Cenník")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    Text("posledná zmena: 13.8.2023")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
                
            }.padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(Color.brandWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        
    }
    
}

//struct GeneralSmallInputBox: View {
//
//    var title: String
//    @Binding var value: Int
//    var unit: UnitsOfMeasurment
//    var isBackgroundWhite: Bool
//
//    var body: some View {
//
//
//        HStack(spacing: 15) {
//
//            Text(title)
//                .font(.system(size: 17, weight: .medium))
//                .foregroundStyle(Color.brandBlack)
//
//            TextField("", value: $value, format: .number)
//                .font(.system(size: 20, weight: .semibold))
//                .foregroundStyle(Color.brandBlack)
//                .multilineTextAlignment(.center)
//                .keyboardType(.numberPad)
//                .frame(width: 65, height: 30)
//                .background(isBackgroundWhite ? Color.brandGray : Color.brandWhite)
//                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//
//            Text(unit.rawValue)
//                .font(.system(size: 17, weight: .medium))
//                .foregroundStyle(Color.brandBlack)
//
//        }
//
//    }
//
//}

struct NewRoomView: View {
    
    @ObservedObject var viewModel: InProjectScreenViewModel
    var project: Project
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Text("Nová Miestnosť")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.brandBlack)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isCreatingNewRoom = false
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
            
            TextField("", text: $viewModel.newRoomName)
                .labelsHidden()
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.brandBlack)
                .placeholder(when: viewModel.newRoomName.isEmpty, placeholder: {
                    Text("Názov Miestnosti")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.brandBlack.opacity(0.7))
                })
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 40)
                .submitLabel(.done)
                .onSubmit { viewModel.createNewRoom(forProject: project) }
                .padding(.bottom, 5)
            
            ScrollView(.horizontal) {
                
                HStack(spacing: 8) {
                    ForEach(viewModel.roomNames, id: \.self) { roomName in
                        Text(roomName)
                            .font(.system(size: 16,weight: .medium))
                            .foregroundStyle(viewModel.newRoomName == roomName ? Color.brandWhite : Color.brandBlack)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(viewModel.newRoomName == roomName ? Color.brandBlack : Color.brandGray)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.leading, roomName == viewModel.roomNames[0] ? 40 : 5)
                            .padding(.trailing, roomName == viewModel.roomNames.last ? 5 : 0)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.newRoomName = roomName
                                }
                            }
                    }
                }
            }.scrollIndicators(.never)
                .padding(.bottom, 20)
            
            
            
            Button {
                viewModel.createNewRoom(forProject: project)
                dismissKeyboard()
            } label: {
                Text("Vytvoriť!")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.brandBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                
            }
            
        }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        
    }
    
}

struct RoomBubbleView: View {
    
    var room: Room
    var isDeleting: Bool
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        HStack {
            
            Text(room.unwrappedName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandBlack)
            //.offset(x: isDeleting ? 80 : 0)
            
            Spacer()
            
            if !isDeleting {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
            }
            
        }.padding(.vertical, 20)
            .padding(.horizontal, 15)
            .background(Color.brandWhite)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.leading, isDeleting ? 80 : 0)
    }
}

struct ArchiveButton: View {
    
    @ObservedObject var viewModel: InProjectScreenViewModel
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Text("\(viewModel.tappedArchiveButton ? "Prajete si vy": "Vy")mazať\(viewModel.tappedArchiveButton ? " projekt?" : "")")
                .font(.system(size: 22, weight: .medium))
            //.foregroundStyle(viewModel.tappedArchiveButton ? Color.brandWhite : Color.brandBlack)
                .foregroundStyle(Color.brandBlack)
            
            Image(systemName: "trash.fill")
                .font(.system(size: 20))
            //.foregroundStyle(viewModel.tappedArchiveButton ? Color.brandWhite : Color.brandBlack)
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
        }.padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(viewModel.tappedArchiveButton ? Color.brandWhite : Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                //.stroke(viewModel.tappedArchiveButton ? Color.brandBlack : Color.white, lineWidth: 3)
                    .stroke(Color.white, lineWidth: 3)
            }
        
    }
    
}

struct RoomsList: View {
    
    var project: Project
    @ObservedObject var viewModel: InProjectScreenViewModel
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest var fetchedRooms: FetchedResults<Room>
    
    init(project: Project, viewModel: InProjectScreenViewModel) {
        
        self.viewModel = viewModel
        
        self.project = project
        
        let fetchRequest = Room.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: true)]
        
        fetchRequest.predicate = NSPredicate(format: "fromProject == %@", project)
        
        _fetchedRooms = FetchRequest(fetchRequest: fetchRequest)
        
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                
                Image(systemName: "square.split.bottomrightquarter.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Text("Miestnosti")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.brandBlack)
                
                Spacer()
                
                Button {
                    viewModel.toggleIsDeleting()
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.brandBlack)
                }.padding(.trailing, 4)
                
                Button {
                    viewModel.toggleIsCreatingRoom()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.brandBlack)
                }
                
            }
            
            if viewModel.isCreatingNewRoom {
                NewRoomView(viewModel: viewModel, project: project)
                    .transition(.scale(scale: 0.0, anchor: .topTrailing))
                    .onAppear{viewModel.isDeletingRooms = false}
            }
            
            ForEach(fetchedRooms) { room in
                
                NavigationLink { RoomScreen(room: room) } label: {
                    RoomBubbleView(room: room, isDeleting: viewModel.isDeletingRooms)
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
}

struct TitleAndNotesView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: InProjectScreenViewModel
    var project: Project
    
    var body: some View {
        VStack {
            
            HStack {
                
                TextField("Názov Projektu", text: $viewModel.projectName)
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(Color.brandBlack)
                    .lineLimit(1)
                    .submitLabel(.done)
                    .onSubmit { viewModel.saveProjectName(project: project) }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 30))
                        .foregroundColor(.brandBlack)
                }
                
            }.padding(.top, 15)
            
            InputNotes(project: project, viewModel: viewModel)
        }
    }
}
