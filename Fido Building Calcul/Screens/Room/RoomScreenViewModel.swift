//
//  RoomScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//

import SwiftUI
import CoreData

@MainActor final class RoomScreenViewModel: ObservableObject {

    private let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var roomName = ""
    
    func saveRoomName(room: Room) {
        if roomName != "" {
            
            room.name = roomName
            
            saveAll()
            
        }
    }
    
    func roomLoading(room: Room) { roomName = room.unwrappedName }
    
    func createDemolitionWork(to room: Room) {
        
        let newDemolitionWork = DemolitionWork(context: viewContext)
        
        withAnimation {
            newDemolitionWork.hours = 0
            newDemolitionWork.fromRoom = room
            saveAll()
        }
        
    }
    
    
    
    func saveAll() {
        withAnimation { try? viewContext.save() }
    }
    
}

