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
    
    @Published var roomName: String = ""
    
    func saveRoomName(room: Room) {
        if roomName != "" {
            
            room.name = roomName
            
            saveAll()
            
        }
    }
    
    func roomLoading(room: Room) { roomName = RoomTypes.rawValueToString(room.unwrappedName) }
    
    
    func saveAll() {
        withAnimation { try? viewContext.save() }
    }
    
}

