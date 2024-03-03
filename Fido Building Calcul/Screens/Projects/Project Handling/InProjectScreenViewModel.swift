//
//  InProjectScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/07/2023.
//

import SwiftUI
import CoreData

@MainActor final class InProjectScreenViewModel: ObservableObject {
    
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    @Published var isDeletingRooms = false
    @Published var projectName = ""
    @Published var projectNotes = ""
    @Published var havingCustomName = false
    @Published var customRoomName = ""
    @Published var saveNotes: Bool = false
    @Published var isCreatingNewRoom: Bool = false
    @Published var isDeletingClientConnection = false
    @Published var isPickingClient = false
    @Published var isShowingPricesList = false
    @Published var tappedArchiveButton = false
    @Published var priceList: PriceList? = nil {
        didSet {
            isShowingPricesList.toggle()
        }
    }
    
    func toggleIsDeleting() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            isDeletingRooms.toggle()
        }
    }
    
    func toggleIsCreatingRoom() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            isCreatingNewRoom.toggle()
        }
    }
    
    func toggleIsDeletingContactConnection() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            isDeletingClientConnection.toggle()
        }
    }
    
    func daysBetween(project: Project) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: project.archivedDate ?? Date.now, to: Date.now)
        return components.day ?? 0
    }
    
    func projectLoading(project: Project) {
        projectName = project.unwrappedName
        projectNotes = project.unwrappedNotes
    }
    
    func saveProjectName(project: Project) {
        if projectName != "" {
            
            let viewContext = PersistenceController.shared.container.viewContext
            
            project.name = projectName
            
            try? viewContext.save()
            
        }
    }
    
    func saveProjectNotes(project: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        project.notes = projectNotes
        
        try? viewContext.save()
        
        saveNotes = false
        
    }
    
    func saveEntireProject(project: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        guard projectName != "" else { return }
        
        project.notes = projectNotes
        project.name = projectName
        
        try? viewContext.save()
        
    }
    
    func createNewRoom(forProject: Project, roomType: RoomTypes) -> Room? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        return withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            
            let room = Room(context: viewContext)
            
            if roomType == .other {
                guard customRoomName != "" else { return nil }
                room.name = customRoomName
            } else {
                room.name = roomType.rawValue
            }
            
            room.cId = UUID()
            room.dateCreated = Date.now
            room.fromProject = forProject
            room.commuteLength = 0.0
            room.daysInWork = 0.0
            room.toolRental = 0.0
            
            try? viewContext.save()
            
            isCreatingNewRoom = false
            
            return room
            
        }
        
    }
    
    func archiveProject(project: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        project.isArchived = true
        project.archivedDate = Date.now
        
        try? viewContext.save()
        
    }
    
}
