//
//  DuplicateProjectButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 18/01/2024.
//

import SwiftUI
import CoreData


@MainActor final class DuplicateProjectViewModel: ObservableObject {
    
    func copyProject(of project: Project) -> Project? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let projectPriceList = project.toPriceList
        let projectClient = project.toClient
        let projectContractor = project.toContractor
        let newProjectNumber = newProjectNumber()
        
        project.toPriceList = nil
        project.toClient = nil
        project.toContractor = nil
        
        let _ = project.copyEntireObjectGraph(context: viewContext)
        
        project.toPriceList = projectPriceList
        project.toClient = projectClient
        project.toContractor = projectContractor
        
        try? viewContext.save()
        
        guard let duplicatedProject = fetchLastProject() else { return nil }
        
        guard let editedProject = editNewProject(of: duplicatedProject, to: projectClient, with: projectPriceList, by: projectContractor, numbered:  newProjectNumber) else { return nil }
        
        do {
            try viewContext.save()
            return editedProject
        } catch {
            return nil
        }
        
    }
    
    private func fetchLastProject() -> Project? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let projectRequest = Project.fetchRequest()
        projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        projectRequest.fetchLimit = 1
        return try? viewContext.fetch(projectRequest).first
        
    }
    
    private func editNewProject(of project: Project, to client: Client?, with priceList: PriceList?, by contractor: Contractor?, numbered: Int64) -> Project? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        print("Run edit project")
        project.cId = UUID()
        project.number = numbered
        project.dateCreated = Date.now
        project.status = 0
        project.name = modifyProjectName(project.unwrappedName)
        project.isArchived = false
        project.archivedDate = nil
        project.toClient = client
        project.toContractor = contractor
        project.addToToHistoryEvent(ProjectEvents.created.entityObject)
        
        guard let _ = copiedPriceListObject(toProject: project, from: priceList) else { return nil }
        
        do {
            try viewContext.save()
            return project
        } catch {
            print(error)
            return nil
        }
        
    }
    
    private func modifyProjectName(_ originalString: String) -> String {
        
        let localizedCopy = NSLocalizedString("Copy", comment: "Suffix indicating a duplicate item")
        
        return "\(originalString) \(localizedCopy)"
        
    }
    
    func newProjectNumber() -> Int64 {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Project.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        
        let fetchedProjects = try? viewContext.fetch(request)
        
        let calendar = Calendar.current
        let currentDate = Date.now
        
        let thisYearProjects = fetchedProjects?.filter { calendar.component(.year, from: $0.dateCreated ?? Date.now) == calendar.component(.year, from: currentDate) }
        
        if let thisYearProjects, !thisYearProjects.isEmpty {
            
            let largestThisYearProjectByNumber = thisYearProjects.max { $0.number < $1.number }
            
            return (largestThisYearProjectByNumber?.number ?? 0) + 1
            
        }
        
        return 1
        
    }
    
    private func copiedPriceListObject(toProject: Project?, from priceList: PriceList?) -> PriceList? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        var substitutePriceList: PriceList?
        
        if let priceList {
            substitutePriceList = priceList
        } else {
            
            let request = PriceList.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
            
            request.predicate = NSPredicate(format: "isGeneral == YES")
            
            let fetchedGeneralPriceList = try? viewContext.fetch(request)
            
            guard let generalPriceList = fetchedGeneralPriceList?.last else { return nil }
            
            substitutePriceList = generalPriceList
            
        }
        
        if let substitutePriceList {
            
            let newPriceList = PriceList(context: viewContext)
            
            newPriceList.cId = UUID()
            newPriceList.dateCreated = Date.now
            newPriceList.dateEdited = Date.now
            newPriceList.isGeneral = false
            
            if let toProject {
                if let existingPriceList = toProject.toPriceList {
                    viewContext.delete(existingPriceList)
                    toProject.toPriceList = nil
                }
                newPriceList.fromProject = toProject
            }
            
            newPriceList.workDemolitionPrice = substitutePriceList.workDemolitionPrice
            newPriceList.workWiringPrice = substitutePriceList.workWiringPrice
            newPriceList.workPlumbingPrice = substitutePriceList.workPlumbingPrice
            newPriceList.workBrickPartitionsPrice = substitutePriceList.workBrickPartitionsPrice
            newPriceList.workBrickLoadBearingWallPrice = substitutePriceList.workBrickLoadBearingWallPrice
            newPriceList.workSimplePlasterboardingPartitionPrice = substitutePriceList.workSimplePlasterboardingPartitionPrice
            newPriceList.workDoublePlasterboardingPartitionPrice = substitutePriceList.workDoublePlasterboardingPartitionPrice
            newPriceList.workTriplePlasterboardingPartitionPrice = substitutePriceList.workTriplePlasterboardingPartitionPrice
            newPriceList.workPlasterboardingCeilingPrice = substitutePriceList.workPlasterboardingCeilingPrice
            newPriceList.workNettingWallPrice = substitutePriceList.workNettingWallPrice
            newPriceList.workNettingCeilingPrice = substitutePriceList.workNettingCeilingPrice
            newPriceList.workPlasteringWallPrice = substitutePriceList.workPlasteringWallPrice
            newPriceList.workPlasteringCeilingPrice = substitutePriceList.workPlasteringCeilingPrice
            newPriceList.workInstallationOfCornerBeadPrice = substitutePriceList.workInstallationOfCornerBeadPrice
            newPriceList.workPlasteringOfWindowSashPrice = substitutePriceList.workPlasteringOfWindowSashPrice
            newPriceList.workPenetrationCoatingPrice = substitutePriceList.workPenetrationCoatingPrice
            newPriceList.workPaintingWallPrice = substitutePriceList.workPaintingWallPrice
            newPriceList.workPaintingCeilingPrice = substitutePriceList.workPaintingCeilingPrice
            newPriceList.workLevellingPrice = substitutePriceList.workLevellingPrice
            newPriceList.workLayingFloatingFloorsPrice = substitutePriceList.workLayingFloatingFloorsPrice
            newPriceList.workSkirtingOfFloatingFloorPrice = substitutePriceList.workSkirtingOfFloatingFloorPrice
            newPriceList.workTilingCeramicPrice = substitutePriceList.workTilingCeramicPrice
            newPriceList.workPavingCeramicPrice = substitutePriceList.workPavingCeramicPrice
            newPriceList.workGroutingPrice = substitutePriceList.workGroutingPrice
            newPriceList.workSiliconingPrice = substitutePriceList.workSiliconingPrice
            newPriceList.workSanitaryCornerValvePrice = substitutePriceList.workSanitaryCornerValvePrice
            newPriceList.workSanitaryStandingMixerTapPrice = substitutePriceList.workSanitaryStandingMixerTapPrice
            newPriceList.workSanitaryWallMountedTapPrice = substitutePriceList.workSanitaryWallMountedTapPrice
            newPriceList.workSanitaryFlushMountedTapPrice = substitutePriceList.workSanitaryFlushMountedTapPrice
            newPriceList.workSanitaryToiletCombiPrice = substitutePriceList.workSanitaryToiletCombiPrice
            newPriceList.workSanitaryToiletWithConcealedCisternPrice = substitutePriceList.workSanitaryToiletWithConcealedCisternPrice
            newPriceList.workSanitarySinkPrice = substitutePriceList.workSanitarySinkPrice
            newPriceList.workSanitarySinkWithCabinetPrice = substitutePriceList.workSanitarySinkWithCabinetPrice
            newPriceList.workSanitaryBathtubPrice = substitutePriceList.workSanitaryBathtubPrice
            newPriceList.workSanitaryShowerCubiclePrice = substitutePriceList.workSanitaryShowerCubiclePrice
            newPriceList.workSanitaryGutterPrice = substitutePriceList.workSanitaryGutterPrice
            newPriceList.workWindowInstallationPrice = substitutePriceList.workWindowInstallationPrice
            newPriceList.workDoorJambInstallationPrice = substitutePriceList.workDoorJambInstallationPrice
            newPriceList.workAuxiliaryAndFinishingPrice = substitutePriceList.workAuxiliaryAndFinishingPrice
            newPriceList.othersToolRentalPrice = substitutePriceList.othersToolRentalPrice
            newPriceList.othersCommutePrice = substitutePriceList.othersCommutePrice
            newPriceList.othersVatPrice = substitutePriceList.othersVatPrice
            newPriceList.materialPartitionMasonryPrice = substitutePriceList.materialPartitionMasonryPrice
            newPriceList.materialLoadBearingMasonryPrice = substitutePriceList.materialLoadBearingMasonryPrice
            newPriceList.materialSimplePlasterboardingPartitionPrice = substitutePriceList.materialSimplePlasterboardingPartitionPrice
            newPriceList.materialDoublePlasterboardingPartitionPrice = substitutePriceList.materialDoublePlasterboardingPartitionPrice
            newPriceList.materialTriplePlasterboardingPartitionPrice = substitutePriceList.materialTriplePlasterboardingPartitionPrice
            newPriceList.materialPlasterboardingCeilingPrice = substitutePriceList.materialPlasterboardingCeilingPrice
            newPriceList.materialMeshPrice = substitutePriceList.materialMeshPrice
            newPriceList.materialAdhesiveNettingPrice = substitutePriceList.materialAdhesiveNettingPrice
            newPriceList.materialAdhesiveTilingAndPavingPrice = substitutePriceList.materialAdhesiveTilingAndPavingPrice
            newPriceList.materialPlasterPrice = substitutePriceList.materialPlasterPrice
            newPriceList.materialCornerBeadPrice = substitutePriceList.materialCornerBeadPrice
            newPriceList.materialPrimerPrice = substitutePriceList.materialPrimerPrice
            newPriceList.materialPaintWallPrice = substitutePriceList.materialPaintWallPrice
            newPriceList.materialPaintCeilingPrice = substitutePriceList.materialPaintCeilingPrice
            newPriceList.materialSelfLevellingCompoundPrice = substitutePriceList.materialSelfLevellingCompoundPrice
            newPriceList.materialFloatingFloorPrice = substitutePriceList.materialFloatingFloorPrice
            newPriceList.materialSkirtingBoardPrice = substitutePriceList.materialSkirtingBoardPrice
            newPriceList.materialSiliconePrice = substitutePriceList.materialSiliconePrice
            newPriceList.materialTilesPrice = substitutePriceList.materialTilesPrice
            newPriceList.materialPavingsPrice = substitutePriceList.materialPavingsPrice
            newPriceList.materialAuxiliaryAndFasteningPrice = substitutePriceList.materialAuxiliaryAndFasteningPrice
            newPriceList.materialSimplePlasterboardingPartitionCapacity = substitutePriceList.materialSimplePlasterboardingPartitionCapacity
            newPriceList.materialDoublePlasterboardingPartitionCapacity = substitutePriceList.materialDoublePlasterboardingPartitionCapacity
            newPriceList.materialTriplePlasterboardingPartitionCapacity = substitutePriceList.materialTriplePlasterboardingPartitionCapacity
            newPriceList.materialPlasterboardingCeilingCapacity = substitutePriceList.materialPlasterboardingCeilingCapacity
            newPriceList.materialAdhesiveNettingCapacity = substitutePriceList.materialAdhesiveNettingCapacity
            newPriceList.materialAdhesiveTilingAndPavingCapacity = substitutePriceList.materialAdhesiveTilingAndPavingCapacity
            newPriceList.materialPlasterCapacity = substitutePriceList.materialPlasterCapacity
            newPriceList.materialCornerBeadCapacity = substitutePriceList.materialCornerBeadCapacity
            newPriceList.materialSelfLevellingCompoundCapacity = substitutePriceList.materialSelfLevellingCompoundCapacity
            newPriceList.materialSiliconeCapacity = substitutePriceList.materialSiliconeCapacity
            
            try? viewContext.save()
            
            return newPriceList
            
        }
        
        return nil
    }
    
}
