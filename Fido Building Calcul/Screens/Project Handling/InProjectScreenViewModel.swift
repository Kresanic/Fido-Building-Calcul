//
//  InProjectScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/07/2023.
//

import SwiftUI
import CoreData

@MainActor final class InProjectScreenViewModel: ObservableObject {
    
    @Published var isDeletingRooms = false
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    @Published var projectName = ""
    @Published var projectNotes = ""
    @Published var projectCommuteLength = 0
    @Published var projectDaysInWork = 0
    @Published var projectToolRental = 0
    @Published var saveNotes: Bool = false
    @Published var isCreatingNewRoom: Bool = false
    @Published var newRoomName = "Chodba"
    @Published var roomNames = ["Chodba", "WC", "Kúpelňa", "Kuchyňa", "Obývačka", "Detská izba", "Spálňa", "Hosťovská", "Pracovňa"]
    @Published var tappedArchiveButton = false
    
    @AppStorage("commute") var commute: Double = 0.50
    @AppStorage("toolRental") var toolRental: Double = 10.00
    
    func toggleIsDeleting() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
            isDeletingRooms.toggle()
        }
    }
    
    func toggleIsCreatingRoom() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.3)) {
            isCreatingNewRoom.toggle()
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
//        projectCommuteLength = Int(project.commuteLength)
//        projectDaysInWork = Int(project.daysInWork)
//        projectToolRental = Int(project.toolRental)
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
//        project.daysInWork = Int64(projectDaysInWork)
//        project.commuteLength = Int64(projectCommuteLength)
//        project.toolRental = Int64(projectToolRental)
        
        try? viewContext.save()
        
    }
    
    func createNewRoom(forProject: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        withAnimation(.easeInOut(duration: 0.3)) {
            
            let room = Room(context: viewContext)
            
            guard newRoomName != "" else { return }
            
            room.cId = UUID()
            room.name = newRoomName
            room.dateCreated = Date.now
            room.fromProject = forProject
            
            try? viewContext.save()
            
            
            isCreatingNewRoom = false
        }
        
        newRoomName = "Chodba"
        
    }
    
    func archiveProject(project: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        project.isArchived = true
        project.archivedDate = Date.now
        
        try? viewContext.save()
        
        
    }
    
//    func commutePrices(project: Project) -> Double {
//        
//        let length = Double(project.commuteLength)
//        
//        let days = Double(project.daysInWork)
//        
//        return days * length * commute
//        
//    }
//    
//    func toolRentalPrices(project: Project) -> Double {
//        
//        let hoursRented = Double(project.toolRental)
//        
//        return hoursRented * toolRental
//        
//    }
//    
//    
//    func totalPriceForCommuteAndTools(project: Project) -> Double {
//        
//        return commutePrices(project: project) + toolRentalPrices(project: project)
//        
//    }
    
    
}
