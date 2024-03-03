//
//  WindowAndDoorEditors.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct DoorEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Door>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FocusState var focusedDimension: FocusedDimension?
    var objectCount: Int
    
    init(door: Door, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = Door.fetchRequest()
        
        let cUUID = door.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Door.dateCreated, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(spacing: 0) {
                
                    Text("No. \(objectCount)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    
                    Button {
                        duplicateDoors(door: fetchedEntity)
                        behavioursVM.redraw()
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                            .padding(.horizontal, 7)
                    }
                    
                    Button {
                        deleteDoors(toDelete: fetchedEntity)
                        behavioursVM.redraw()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                            .padding(.leading, 7)
                            .padding(.trailing, 5)
                    }
                    
                }
                
                VStack {
                    
                    ValueEditingBoxSmall(title: .width, value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                    .focused($focusedDimension, equals: .first)
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    ValueEditingBoxSmall(title: .height, value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $height)
                
            }.padding(.horizontal, 5)
                .transition(.scale)
            
        }
        
    }
    
    func createDoor<T: WorkType>(to workType: T) {
        
        let newDoor = Door(context: viewContext)
        
        newDoor.cId = UUID()
        newDoor.size1 = stringToDouble(from: width)
        newDoor.size2 = stringToDouble(from: height)
        newDoor.dateCreated = Date.now
        if workType is BrickPartition {
            newDoor.inBrickPartition = workType as? BrickPartition
        } else if workType is BrickLoadBearingWall {
            newDoor.inBrickLoadBearingWall = workType as? BrickLoadBearingWall
        } else if workType is PlasterboardingPartition {
            newDoor.inPlasterboardingPartition = workType as? PlasterboardingPartition
        } else if workType is NettingWall {
            newDoor.inNettingWall = workType as? NettingWall
        } else if workType is PlasteringWall {
            newDoor.inPlasteringWall = workType as? PlasteringWall
        }
        
        saveAll()
        
    }
    
    func duplicateDoors(door: Door) {
        
        if let brickPartition = door.inBrickPartition {
            createDoor(to: brickPartition)
        } else if let brickLoadBearingWall = door.inBrickLoadBearingWall {
            createDoor(to: brickLoadBearingWall)
        } else if let plasterBoardingPartition = door.inPlasterboardingPartition {
            createDoor(to: plasterBoardingPartition)
        } else if let nettingWall = door.inNettingWall {
            createDoor(to: nettingWall)
        } else if let plasteringWall = door.inPlasteringWall {
            createDoor(to: plasteringWall)
        }
        
    }
    
    func deleteDoors(toDelete: Door) {

        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = Door.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \Door.size1, ascending: true)]

        let cUUID = toDelete.cId ?? UUID()
        
        requestObjectsToDelete.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)

        let fetchedObjectsToDelete = try? viewContext.fetch(requestObjectsToDelete)

        if let objectsToDelete = fetchedObjectsToDelete {

            for objectToDelete in objectsToDelete {
                viewContext.delete(objectToDelete)
            }
            
            saveAll()

        }

    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}

struct WindowEditor: View {
    
    @FetchRequest var fetchedEntities: FetchedResults<Window>
    @State var width = ""
    @State var height = ""
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    var objectCount: Int
    @FocusState var focusedDimension: FocusedDimension?
    
    init(window: Window, objectCount: Int) {
        
        self.objectCount = objectCount
        
        let entityRequest = Window.fetchRequest()
        
        let cUUID = window.cId ?? UUID()
        
        entityRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Window.dateCreated, ascending: true)]
        
        entityRequest.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)
        
        _fetchedEntities = FetchRequest(fetchRequest: entityRequest)
        
    }
    
    var body: some View {
        
        if let fetchedEntity = fetchedEntities.first {
            
            VStack {
                
                HStack(spacing: 0) {
                
                    Text("No. \(objectCount)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    Button {
                        duplicateWindows(window: fetchedEntity)
                        behavioursVM.redraw()
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                            .padding(.horizontal, 7)
                    }
                    
                    
                    Button {
                        dismissKeyboard()
                        deleteWindows(toDelete: fetchedEntity)
                        behavioursVM.redraw()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.brandBlack)
                            .padding(.leading, 7)
                            .padding(.trailing, 5)
                    }
                    
                }
                
                VStack {
                    
                    ValueEditingBoxSmall(title: .width, value: $width, unit: .meter)
                        .onAppear { width = doubleToString(from: fetchedEntity.size1) }
                    .focused($focusedDimension, equals: .first)
                        .onChange(of: width) { _ in
                            fetchedEntity.size1 = stringToDouble(from: width)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                    ValueEditingBoxSmall(title: .height, value: $height, unit: .meter)
                        .onAppear { height = doubleToString(from: fetchedEntity.size2) }
                    .focused($focusedDimension, equals: .second)
                        .onChange(of: height) { _ in
                            fetchedEntity.size2 = stringToDouble(from: height)
                            try? viewContext.save()
                            behavioursVM.redraw()
                        }
                    
                }.task { if fetchedEntity.dateCreated ?? Date.now >= Date().addingTimeInterval(-10) { withAnimation { focusedDimension = .first } } }
                    .workInputsToolbar(focusedDimension: $focusedDimension, size1: $width, size2: $height)
                
            }.padding(.horizontal, 5)
                .transition(.scale)
            
        }
        
    }
    
    func createWindow<T: WorkType>(to workType: T) {
        
        let newWindow = Window(context: viewContext)
        
        newWindow.cId = UUID()
        newWindow.size1 = stringToDouble(from: width)
        newWindow.size2 = stringToDouble(from: height)
        newWindow.dateCreated = Date.now
        if workType is BrickPartition {
            newWindow.inBrickPartition = workType as? BrickPartition
        } else if workType is BrickLoadBearingWall {
            newWindow.inBrickLoadBearingWall = workType as? BrickLoadBearingWall
        } else if workType is PlasterboardingPartition {
            newWindow.inPlasterboardingPartition = workType as? PlasterboardingPartition
        } else if workType is PlasterboardingCeiling {
            newWindow.inPlasterboardingCeiling = workType as? PlasterboardingCeiling
        } else if workType is NettingWall {
            newWindow.inNettingWall = workType as? NettingWall
        } else if workType is PlasteringWall {
            newWindow.inPlasteringWall = workType as? PlasteringWall
        }
        
        saveAll()
        
    }
    
    func duplicateWindows(window: Window) {
        
        if let brickPartition = window.inBrickPartition {
            createWindow(to: brickPartition)
        } else if let brickLoadBearingWall = window.inBrickLoadBearingWall {
            createWindow(to: brickLoadBearingWall)
        } else if let plasterBoardingPartition = window.inPlasterboardingPartition {
            createWindow(to: plasterBoardingPartition)
        } else if let plasterBoardingCeiling = window.inPlasterboardingCeiling {
            createWindow(to: plasterBoardingCeiling)
        } else if let nettingWall = window.inNettingWall {
            createWindow(to: nettingWall)
        } else if let plasteringWall = window.inPlasteringWall {
            createWindow(to: plasteringWall)
        }
        
    }
    
    func deleteWindows(toDelete: Window) {

        if focusedDimension != nil { focusedDimension = nil }
        
        let requestObjectsToDelete = Window.fetchRequest()

        requestObjectsToDelete.sortDescriptors = [NSSortDescriptor(keyPath: \Window.size1, ascending: true)]

        let cUUID = toDelete.cId ?? UUID()
        
        requestObjectsToDelete.predicate = NSPredicate(format: "cId == %@", cUUID as CVarArg)

        let fetchedObjectsToDelete = try? viewContext.fetch(requestObjectsToDelete)

        if let objectsToDelete = fetchedObjectsToDelete {

            for objectToDelete in objectsToDelete {
                viewContext.delete(objectToDelete)
            }
            
            saveAll()

        }

    }
    
    func saveAll() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) { try? viewContext.save() }
    }
    
}
