//
//  BehavioursViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI
import RevenueCat
import CoreData

final class BehavioursViewModel: ObservableObject {
    
    @AppStorage("archiveForDays") var archiveForDays: Int = 30
    @AppStorage("activeContractor") var activeContractorCID: UUID?
    @AppStorage("hasRetrievedOldContractors") var hasRetrievedOldContractors = false
    @Published var activeContractor: Contractor? {
        didSet {
            activeContractorCID = activeContractor?.cId
        }
    }
    @Published var currentTab: CustomTabs = .projects
    @Published var toRedraw = false
    @Published var projectsPath = NavigationPath()
    @Published var invoicesPath = NavigationPath()
    @Published var clientsPath = NavigationPath()
    @Published var settingsPath = NavigationPath()
    @Published var isAnimationCircular = false
    @Published var isUserPro = false
    @Published var givenPromotional = false
    @Published var promotionalEntitlements = false
    let givePromotionalForMonths: Int = 6
    @Published var showingNotification: String? = nil
    @Published var showingDialogWindow: Dialog? = nil
    @AppStorage("hasNotSeenOnboarding") var hasNotSeenOnboarding: Bool = true
    @AppStorage("appearancePrefferance") var prefferesAppearance: Int = 0
    
    init() {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                withAnimation(.easeInOut) {
                    self.isUserPro = true
                }
            }
        }
        
        assignContractor()
        
        hasAnyClientContractorCheck()
        
    }
    
    func proEntitlementHandling() async {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                withAnimation(.easeInOut) {
                    self.isUserPro = true
                }
            }
        }
        
        await MainActor.run {
            self.promotionalEntitlements = true
        }
        
    }
    
    func windowingForPromotionalEntitlements() async {
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        let isApril2024 = components.year == 2024 && components.month == 4
        
        if isApril2024 && !isUserPro { try? await grantPromotionalEntitlement() }
        
    }
    
    func grantPromotionalEntitlement() async throws {
        
        let appUserID = Purchases.shared.appUserID
        let url = URL(string: "https://api.revenuecat.com/v1/subscribers/\(appUserID)/entitlements/Pro/promotional")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer sk_puuududJBAxTZDOuimFLoJJgqORLv", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "start_time_ms": Int(Date().timeIntervalSince1970 * 1000),
            "end_time_ms": Int(Calendar.current.date(byAdding: .month, value: givePromotionalForMonths, to: Date())!.timeIntervalSince1970 * 1000)
        ]
        
        print(Date().iso8601, Calendar.current.date(byAdding: .month, value: 6, to: Date())!.iso8601)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 && httpResponse.statusCode > 199  else {
            print("Error with the request")
            print(response)
            return
        }
        
        await MainActor.run {
            self.givenPromotional = true
            self.isUserPro = true
        }
        
        print("Successful entitlement grant: \(data)")
    }

    
    func hasAnyClientContractorCheck() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Client.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.name, ascending: true)]
        
        request.predicate = NSPredicate(format: "isUser == true")
        
        let fetchedClients = try? viewContext.fetch(request)
        
        if let fetchedClients {
            contractorVersionAntiDataLoss(fetchedClients: fetchedClients)
        }
        
        let requestContr = Contractor.fetchRequest()
        
        requestContr.sortDescriptors = [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: true)]
        
        requestContr.fetchLimit = 1
        
        let fetchedContractor = try? viewContext.fetch(requestContr).first
        
        if let fetchedContractor { reAssignProjectsToContractor(contractor: fetchedContractor) }
            
    }
    
    func contractorVersionAntiDataLoss(fetchedClients: [Client]) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        for client in fetchedClients {
            
            let newContractor = Contractor(context: viewContext)
            
            newContractor.cId = UUID()
            newContractor.name = client.name
            newContractor.businessID = client.businessID
            newContractor.bankAccountNumber = client.bankAccountNumber
            newContractor.city = client.city
            newContractor.contactPersonName = client.contactPersonName
            newContractor.country = client.country
            newContractor.email = client.email
            newContractor.legalNotice = client.legalNotice
            newContractor.logo = client.logo
            newContractor.phone = client.phone
            newContractor.postalCode = client.postalCode
            newContractor.secondRowStreet = client.secondRowStreet
            newContractor.street = client.street
            newContractor.swiftCode = client.swiftCode
            newContractor.taxID = client.taxID
            newContractor.vatRegistrationNumber = client.vatRegistrationNumber
            newContractor.web = client.web
            newContractor.dateCreated = client.dateCreated
                
            try? viewContext.save()
            
            viewContext.delete(client)
            
        }
          
    }
    
    func reAssignProjectsToContractor(contractor: Contractor) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Project.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: true)]
        
        request.predicate = NSPredicate(format: "toContractor == nil")
            
        let fetchedProjects = try? viewContext.fetch(request)
        
        if let fetchedProjects {
            for project in fetchedProjects {
                project.toContractor = contractor
            }
        }
        
        try? viewContext.save()
        
    }
    
    func assignContractor() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Contractor.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: true)]
        
        if let cid = activeContractorCID {
            
            request.predicate = NSPredicate(format: "cId == %@", cid as CVarArg)
            
            request.fetchLimit = 1
            
            let fetchedContractor = try? viewContext.fetch(request).first
            
            if let fetchedContractor { withAnimation { activeContractor = fetchedContractor } }
            
        } else {
            
            request.fetchLimit = 1
            
            let fetchedContractor = try? viewContext.fetch(request).first
            
            if let fetchedContractor { withAnimation { activeContractor = fetchedContractor } }
            
        }
        
    }
    
    func showDialogWindow(using dialog: Dialog) {
        showingDialogWindow = dialog
    }
    
    func switchToRoom(with room: Room) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentTab = .projects
            projectsPath.append(room)
        }
    }
    
    func dropProjectFromPath() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.projectsPath.removeLast(1)
        }
    }
    
    func replaceProjectsInPath(with project: Project) {
        // does not wokr
        withAnimation(.easeInOut(duration: 0.2)) {
            self.projectsPath.removeLast(1)
            self.projectsPath.append(project)
        }
    }
    
    func switchToProjectsPage(with project: Project) {
        isAnimationCircular = true
        withAnimation(.easeInOut(duration: 0.2)) {
            currentTab = .projects
            projectsPath.removeLast(projectsPath.count)
            if let projectCat = PropertyCategories(rawValue: project.category ?? "flats") {
                projectsPath.append(projectCat)
            }
            projectsPath.append(project)
        }
        isAnimationCircular = false
    }
    
    func appearancePrefferance() -> ColorScheme? {
        switch prefferesAppearance {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return .none
        }
    }
    
    func setAppearance(to colorScheme: ColorScheme?) {
        withAnimation {
            switch colorScheme {
            case .light:
                prefferesAppearance = 1
            case .dark:
                prefferesAppearance = 2
            case nil:
                prefferesAppearance = 0
            case .some(_):
                prefferesAppearance = 0
            }
        }
    }
    
    func redraw() { withAnimation(.easeInOut(duration: 0.3)) { toRedraw.toggle() } }
    
    func generalPriceListObject(toProject: Project?) -> PriceList? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == YES")
        
        let fetchedGeneralPriceList = try? viewContext.fetch(request)
        
        guard let generalPriceList = fetchedGeneralPriceList?.last else { return nil }
        
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
        
        newPriceList.workDemolitionPrice = generalPriceList.workDemolitionPrice
        newPriceList.workWiringPrice = generalPriceList.workWiringPrice
        newPriceList.workPlumbingPrice = generalPriceList.workPlumbingPrice
        newPriceList.workBrickPartitionsPrice = generalPriceList.workBrickPartitionsPrice
        newPriceList.workBrickLoadBearingWallPrice = generalPriceList.workBrickLoadBearingWallPrice
        newPriceList.workSimplePlasterboardingPartitionPrice = generalPriceList.workSimplePlasterboardingPartitionPrice
        newPriceList.workDoublePlasterboardingPartitionPrice = generalPriceList.workDoublePlasterboardingPartitionPrice
        newPriceList.workTriplePlasterboardingPartitionPrice = generalPriceList.workTriplePlasterboardingPartitionPrice
        newPriceList.workSimplePlasterboardingOffsetWallPrice = generalPriceList.workSimplePlasterboardingOffsetWallPrice
        newPriceList.workDoublePlasterboardingOffsetWallPrice = generalPriceList.workDoublePlasterboardingOffsetWallPrice
        newPriceList.workPlasterboardingCeilingPrice = generalPriceList.workPlasterboardingCeilingPrice
        newPriceList.workNettingWallPrice = generalPriceList.workNettingWallPrice
        newPriceList.workNettingCeilingPrice = generalPriceList.workNettingCeilingPrice
        newPriceList.workPlasteringWallPrice = generalPriceList.workPlasteringWallPrice
        newPriceList.workPlasteringCeilingPrice = generalPriceList.workPlasteringCeilingPrice
        newPriceList.workFacadePlastering = generalPriceList.workFacadePlastering
        newPriceList.workInstallationOfCornerBeadPrice = generalPriceList.workInstallationOfCornerBeadPrice
        newPriceList.workPlasteringOfWindowSashPrice = generalPriceList.workPlasteringOfWindowSashPrice
        newPriceList.workPenetrationCoatingPrice = generalPriceList.workPenetrationCoatingPrice
        newPriceList.workPaintingWallPrice = generalPriceList.workPaintingWallPrice
        newPriceList.workPaintingCeilingPrice = generalPriceList.workPaintingCeilingPrice
        newPriceList.workLevellingPrice = generalPriceList.workLevellingPrice
        newPriceList.workLayingFloatingFloorsPrice = generalPriceList.workLayingFloatingFloorsPrice
        newPriceList.workSkirtingOfFloatingFloorPrice = generalPriceList.workSkirtingOfFloatingFloorPrice
        newPriceList.workTilingCeramicPrice = generalPriceList.workTilingCeramicPrice
        newPriceList.workPavingCeramicPrice = generalPriceList.workPavingCeramicPrice
        newPriceList.workGroutingPrice = generalPriceList.workGroutingPrice
        newPriceList.workSiliconingPrice = generalPriceList.workSiliconingPrice
        newPriceList.workSanitaryCornerValvePrice = generalPriceList.workSanitaryCornerValvePrice
        newPriceList.workSanitaryStandingMixerTapPrice = generalPriceList.workSanitaryStandingMixerTapPrice
        newPriceList.workSanitaryWallMountedTapPrice = generalPriceList.workSanitaryWallMountedTapPrice
        newPriceList.workSanitaryFlushMountedTapPrice = generalPriceList.workSanitaryFlushMountedTapPrice
        newPriceList.workSanitaryToiletCombiPrice = generalPriceList.workSanitaryToiletCombiPrice
        newPriceList.workSanitaryToiletWithConcealedCisternPrice = generalPriceList.workSanitaryToiletWithConcealedCisternPrice
        newPriceList.workSanitarySinkPrice = generalPriceList.workSanitarySinkPrice
        newPriceList.workSanitarySinkWithCabinetPrice = generalPriceList.workSanitarySinkWithCabinetPrice
        newPriceList.workSanitaryBathtubPrice = generalPriceList.workSanitaryBathtubPrice
        newPriceList.workSanitaryShowerCubiclePrice = generalPriceList.workSanitaryShowerCubiclePrice
        newPriceList.workSanitaryGutterPrice = generalPriceList.workSanitaryGutterPrice
        newPriceList.workWindowInstallationPrice = generalPriceList.workWindowInstallationPrice
        newPriceList.workDoorJambInstallationPrice = generalPriceList.workDoorJambInstallationPrice
        newPriceList.workAuxiliaryAndFinishingPrice = generalPriceList.workAuxiliaryAndFinishingPrice
        newPriceList.othersScaffoldingPrice = generalPriceList.othersScaffoldingPrice
        newPriceList.othersScaffoldingAssemblyAndDisassemblyPrice = generalPriceList.othersScaffoldingAssemblyAndDisassemblyPrice
        newPriceList.othersCoreDrillRentalPrice = generalPriceList.othersCoreDrillRentalPrice
        newPriceList.othersToolRentalPrice = generalPriceList.othersToolRentalPrice
        newPriceList.othersCommutePrice = generalPriceList.othersCommutePrice
        newPriceList.othersVatPrice = generalPriceList.othersVatPrice
        newPriceList.materialPartitionMasonryPrice = generalPriceList.materialPartitionMasonryPrice
        newPriceList.materialLoadBearingMasonryPrice = generalPriceList.materialLoadBearingMasonryPrice
        newPriceList.materialSimplePlasterboardingPartitionPrice = generalPriceList.materialSimplePlasterboardingPartitionPrice
        newPriceList.materialDoublePlasterboardingPartitionPrice = generalPriceList.materialDoublePlasterboardingPartitionPrice
        newPriceList.materialTriplePlasterboardingPartitionPrice = generalPriceList.materialTriplePlasterboardingPartitionPrice
        newPriceList.materialSimplePlasterboardingOffsetWallPrice = generalPriceList.materialSimplePlasterboardingOffsetWallPrice
        newPriceList.materialDoublePlasterboardingOffsetWallPrice = generalPriceList.materialDoublePlasterboardingOffsetWallPrice
        newPriceList.materialPlasterboardingCeilingPrice = generalPriceList.materialPlasterboardingCeilingPrice
        newPriceList.materialMeshPrice = generalPriceList.materialMeshPrice
        newPriceList.materialAdhesiveNettingPrice = generalPriceList.materialAdhesiveNettingPrice
        newPriceList.materialAdhesiveTilingAndPavingPrice = generalPriceList.materialAdhesiveTilingAndPavingPrice
        newPriceList.materialPlasterPrice = generalPriceList.materialPlasterPrice
        newPriceList.materialFacadePlasterPrice = generalPriceList.materialFacadePlasterPrice
        newPriceList.materialFacadePlasterCapacity = generalPriceList.materialFacadePlasterCapacity
        newPriceList.materialCornerBeadPrice = generalPriceList.materialCornerBeadPrice
        newPriceList.materialPrimerPrice = generalPriceList.materialPrimerPrice
        newPriceList.materialPaintWallPrice = generalPriceList.materialPaintWallPrice
        newPriceList.materialPaintCeilingPrice = generalPriceList.materialPaintCeilingPrice
        newPriceList.materialSelfLevellingCompoundPrice = generalPriceList.materialSelfLevellingCompoundPrice
        newPriceList.materialFloatingFloorPrice = generalPriceList.materialFloatingFloorPrice
        newPriceList.materialSkirtingBoardPrice = generalPriceList.materialSkirtingBoardPrice
        newPriceList.materialSiliconePrice = generalPriceList.materialSiliconePrice
        newPriceList.materialTilesPrice = generalPriceList.materialTilesPrice
        newPriceList.materialPavingsPrice = generalPriceList.materialPavingsPrice
        newPriceList.materialAuxiliaryAndFasteningPrice = generalPriceList.materialAuxiliaryAndFasteningPrice
        newPriceList.materialSimplePlasterboardingPartitionCapacity = generalPriceList.materialSimplePlasterboardingPartitionCapacity
        newPriceList.materialDoublePlasterboardingPartitionCapacity = generalPriceList.materialDoublePlasterboardingPartitionCapacity
        newPriceList.materialTriplePlasterboardingPartitionCapacity = generalPriceList.materialTriplePlasterboardingPartitionCapacity
        newPriceList.materialSimplePlasterboardingOffsetWallCapacity = generalPriceList.materialSimplePlasterboardingOffsetWallCapacity
        newPriceList.materialDoublePlasterboardingOffsetWallCapacity = generalPriceList.materialDoublePlasterboardingOffsetWallCapacity 
        newPriceList.materialPlasterboardingCeilingCapacity = generalPriceList.materialPlasterboardingCeilingCapacity
        newPriceList.materialAdhesiveNettingCapacity = generalPriceList.materialAdhesiveNettingCapacity
        newPriceList.materialAdhesiveTilingAndPavingCapacity = generalPriceList.materialAdhesiveTilingAndPavingCapacity
        newPriceList.materialPlasterCapacity = generalPriceList.materialPlasterCapacity
        newPriceList.materialCornerBeadCapacity = generalPriceList.materialCornerBeadCapacity
        newPriceList.materialSelfLevellingCompoundCapacity = generalPriceList.materialSelfLevellingCompoundCapacity
        newPriceList.materialSiliconeCapacity = generalPriceList.materialSiliconeCapacity
        
        return newPriceList
        
    }
    
    func copyOfPriceList(from project: Project) -> PriceList? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        guard let originalPriceList = project.toPriceList else { return nil }
        
        let newPriceList = PriceList(context: viewContext)
        
        newPriceList.cId = UUID()
        newPriceList.dateCreated = Date.now
        newPriceList.dateEdited = Date.now
        newPriceList.isGeneral = false
        
        newPriceList.workDemolitionPrice = originalPriceList.workDemolitionPrice
        newPriceList.workWiringPrice = originalPriceList.workWiringPrice
        newPriceList.workPlumbingPrice = originalPriceList.workPlumbingPrice
        newPriceList.workBrickPartitionsPrice = originalPriceList.workBrickPartitionsPrice
        newPriceList.workBrickLoadBearingWallPrice = originalPriceList.workBrickLoadBearingWallPrice
        newPriceList.workSimplePlasterboardingPartitionPrice = originalPriceList.workSimplePlasterboardingPartitionPrice
        newPriceList.workDoublePlasterboardingPartitionPrice = originalPriceList.workDoublePlasterboardingPartitionPrice
        newPriceList.workTriplePlasterboardingPartitionPrice = originalPriceList.workTriplePlasterboardingPartitionPrice
        newPriceList.workSimplePlasterboardingOffsetWallPrice = originalPriceList.workSimplePlasterboardingOffsetWallPrice
        newPriceList.workDoublePlasterboardingOffsetWallPrice = originalPriceList.workDoublePlasterboardingOffsetWallPrice
        newPriceList.workPlasterboardingCeilingPrice = originalPriceList.workPlasterboardingCeilingPrice
        newPriceList.workNettingWallPrice = originalPriceList.workNettingWallPrice
        newPriceList.workNettingCeilingPrice = originalPriceList.workNettingCeilingPrice
        newPriceList.workPlasteringWallPrice = originalPriceList.workPlasteringWallPrice
        newPriceList.workPlasteringCeilingPrice = originalPriceList.workPlasteringCeilingPrice
        newPriceList.workFacadePlastering = originalPriceList.workFacadePlastering
        newPriceList.workInstallationOfCornerBeadPrice = originalPriceList.workInstallationOfCornerBeadPrice
        newPriceList.workPlasteringOfWindowSashPrice = originalPriceList.workPlasteringOfWindowSashPrice
        newPriceList.workPenetrationCoatingPrice = originalPriceList.workPenetrationCoatingPrice
        newPriceList.workPaintingWallPrice = originalPriceList.workPaintingWallPrice
        newPriceList.workPaintingCeilingPrice = originalPriceList.workPaintingCeilingPrice
        newPriceList.workLevellingPrice = originalPriceList.workLevellingPrice
        newPriceList.workLayingFloatingFloorsPrice = originalPriceList.workLayingFloatingFloorsPrice
        newPriceList.workSkirtingOfFloatingFloorPrice = originalPriceList.workSkirtingOfFloatingFloorPrice
        newPriceList.workTilingCeramicPrice = originalPriceList.workTilingCeramicPrice
        newPriceList.workPavingCeramicPrice = originalPriceList.workPavingCeramicPrice
        newPriceList.workGroutingPrice = originalPriceList.workGroutingPrice
        newPriceList.workSiliconingPrice = originalPriceList.workSiliconingPrice
        newPriceList.workSanitaryCornerValvePrice = originalPriceList.workSanitaryCornerValvePrice
        newPriceList.workSanitaryStandingMixerTapPrice = originalPriceList.workSanitaryStandingMixerTapPrice
        newPriceList.workSanitaryWallMountedTapPrice = originalPriceList.workSanitaryWallMountedTapPrice
        newPriceList.workSanitaryFlushMountedTapPrice = originalPriceList.workSanitaryFlushMountedTapPrice
        newPriceList.workSanitaryToiletCombiPrice = originalPriceList.workSanitaryToiletCombiPrice
        newPriceList.workSanitaryToiletWithConcealedCisternPrice = originalPriceList.workSanitaryToiletWithConcealedCisternPrice
        newPriceList.workSanitarySinkPrice = originalPriceList.workSanitarySinkPrice
        newPriceList.workSanitarySinkWithCabinetPrice = originalPriceList.workSanitarySinkWithCabinetPrice
        newPriceList.workSanitaryBathtubPrice = originalPriceList.workSanitaryBathtubPrice
        newPriceList.workSanitaryShowerCubiclePrice = originalPriceList.workSanitaryShowerCubiclePrice
        newPriceList.workSanitaryGutterPrice = originalPriceList.workSanitaryGutterPrice
        newPriceList.workWindowInstallationPrice = originalPriceList.workWindowInstallationPrice
        newPriceList.workDoorJambInstallationPrice = originalPriceList.workDoorJambInstallationPrice
        newPriceList.workAuxiliaryAndFinishingPrice = originalPriceList.workAuxiliaryAndFinishingPrice
        newPriceList.othersScaffoldingPrice = originalPriceList.othersScaffoldingPrice
        newPriceList.othersScaffoldingAssemblyAndDisassemblyPrice = originalPriceList.othersScaffoldingAssemblyAndDisassemblyPrice
        newPriceList.othersCoreDrillRentalPrice = originalPriceList.othersCoreDrillRentalPrice
        newPriceList.othersToolRentalPrice = originalPriceList.othersToolRentalPrice
        newPriceList.othersCommutePrice = originalPriceList.othersCommutePrice
        newPriceList.othersVatPrice = originalPriceList.othersVatPrice
        newPriceList.materialPartitionMasonryPrice = originalPriceList.materialPartitionMasonryPrice
        newPriceList.materialLoadBearingMasonryPrice = originalPriceList.materialLoadBearingMasonryPrice
        newPriceList.materialSimplePlasterboardingPartitionPrice = originalPriceList.materialSimplePlasterboardingPartitionPrice
        newPriceList.materialDoublePlasterboardingPartitionPrice = originalPriceList.materialDoublePlasterboardingPartitionPrice
        newPriceList.materialTriplePlasterboardingPartitionPrice = originalPriceList.materialTriplePlasterboardingPartitionPrice
        newPriceList.materialSimplePlasterboardingOffsetWallPrice = originalPriceList.materialSimplePlasterboardingOffsetWallPrice
        newPriceList.materialDoublePlasterboardingOffsetWallPrice = originalPriceList.materialDoublePlasterboardingOffsetWallPrice
        newPriceList.materialPlasterboardingCeilingPrice = originalPriceList.materialPlasterboardingCeilingPrice
        newPriceList.materialMeshPrice = originalPriceList.materialMeshPrice
        newPriceList.materialAdhesiveNettingPrice = originalPriceList.materialAdhesiveNettingPrice
        newPriceList.materialAdhesiveTilingAndPavingPrice = originalPriceList.materialAdhesiveTilingAndPavingPrice
        newPriceList.materialPlasterPrice = originalPriceList.materialPlasterPrice
        newPriceList.materialFacadePlasterPrice = originalPriceList.materialFacadePlasterPrice
        newPriceList.materialFacadePlasterCapacity = originalPriceList.materialFacadePlasterCapacity
        newPriceList.materialCornerBeadPrice = originalPriceList.materialCornerBeadPrice
        newPriceList.materialPrimerPrice = originalPriceList.materialPrimerPrice
        newPriceList.materialPaintWallPrice = originalPriceList.materialPaintWallPrice
        newPriceList.materialPaintCeilingPrice = originalPriceList.materialPaintCeilingPrice
        newPriceList.materialSelfLevellingCompoundPrice = originalPriceList.materialSelfLevellingCompoundPrice
        newPriceList.materialFloatingFloorPrice = originalPriceList.materialFloatingFloorPrice
        newPriceList.materialSkirtingBoardPrice = originalPriceList.materialSkirtingBoardPrice
        newPriceList.materialSiliconePrice = originalPriceList.materialSiliconePrice
        newPriceList.materialTilesPrice = originalPriceList.materialTilesPrice
        newPriceList.materialPavingsPrice = originalPriceList.materialPavingsPrice
        newPriceList.materialAuxiliaryAndFasteningPrice = originalPriceList.materialAuxiliaryAndFasteningPrice
        newPriceList.materialSimplePlasterboardingPartitionCapacity = originalPriceList.materialSimplePlasterboardingPartitionCapacity
        newPriceList.materialDoublePlasterboardingPartitionCapacity = originalPriceList.materialDoublePlasterboardingPartitionCapacity
        newPriceList.materialTriplePlasterboardingPartitionCapacity = originalPriceList.materialTriplePlasterboardingPartitionCapacity
        newPriceList.materialSimplePlasterboardingOffsetWallCapacity = originalPriceList.materialSimplePlasterboardingOffsetWallCapacity
        newPriceList.materialDoublePlasterboardingOffsetWallCapacity = originalPriceList.materialDoublePlasterboardingOffsetWallCapacity
        newPriceList.materialPlasterboardingCeilingCapacity = originalPriceList.materialPlasterboardingCeilingCapacity
        newPriceList.materialAdhesiveNettingCapacity = originalPriceList.materialAdhesiveNettingCapacity
        newPriceList.materialAdhesiveTilingAndPavingCapacity = originalPriceList.materialAdhesiveTilingAndPavingCapacity
        newPriceList.materialPlasterCapacity = originalPriceList.materialPlasterCapacity
        newPriceList.materialCornerBeadCapacity = originalPriceList.materialCornerBeadCapacity
        newPriceList.materialSelfLevellingCompoundCapacity = originalPriceList.materialSelfLevellingCompoundCapacity
        newPriceList.materialSiliconeCapacity = originalPriceList.materialSiliconeCapacity
        
        return newPriceList
        
    }
    
    func deleteArchivedProjects() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Project.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.archivedDate, ascending: false)]
        
        request.predicate = NSPredicate(format: "isArchived == YES")
        
        if let archivedProjects = try? viewContext.fetch(request) {
            
            for project in archivedProjects {
                
                if daysSince(project: project) > (archiveForDays) {
                    viewContext.delete(project)
                    try? viewContext.save()
                }
                
            }
            
        }
        
    }
    
    func daysSince(project: Project) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: project.archivedDate ?? Date.now, to: Date.now)
        return components.day ?? 0
    }
    
    func createGeneralPriceList() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let mockPriceList = PriceList(context: viewContext)
        
        mockPriceList.cId = UUID()
        mockPriceList.dateCreated = Date.now
        mockPriceList.isGeneral = true
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
            try? viewContext.save()
        }
        
    }
    
    func checkCheckForGeneralPriceList() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateCreated, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == YES")
        
        var fetchedPriceLists: [PriceList] = []
        
        do {
            fetchedPriceLists = try viewContext.fetch(request)
        } catch {
            fetchedPriceLists = []
        }
        
        
        if fetchedPriceLists.count == 1 {
            return
        } else if fetchedPriceLists.count < 1 {
            createGeneralPriceList()
        } else if fetchedPriceLists.count > 1 {
            
            let comparableList = fetchedPriceLists.first
            
            for list in fetchedPriceLists {
                if list != comparableList {
                    viewContext.delete(list)
                }
            }
            
            try? viewContext.save()
            
        }
        
    }
    
    func newProjectNumber() -> Int64 {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Project.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        
        guard let activeContractor else {
            
            let fetchedProjects = try? viewContext.fetch(request)
            
            let calendar = Calendar.current
            let currentDate = Date.now
            
            let thisYearProjects = fetchedProjects?.filter { calendar.component(.year, from: $0.dateCreated ?? Date.now) == calendar.component(.year, from: currentDate) }
            
            if let thisYearProjects {
                
                let largestThisYearProjectByNumber = thisYearProjects.max { $0.number < $1.number }
                
                return (largestThisYearProjectByNumber?.number ?? 0) + 1
                
            }
            
            return 0
            
        }
        
        request.predicate = NSPredicate(format: "toContractor == %@", activeContractor)
        
        let fetchedProjects = try? viewContext.fetch(request)
        
        let calendar = Calendar.current
        let currentDate = Date.now
        
        let thisYearProjects = fetchedProjects?.filter { calendar.component(.year, from: $0.dateCreated ?? Date.now) == calendar.component(.year, from: currentDate) }
        
        if let thisYearProjects {
            
            let largestThisYearProjectByNumber = thisYearProjects.max { $0.number < $1.number }
            
            return (largestThisYearProjectByNumber?.number ?? 0) + 1
            
        }
        
        return 0
        
    }
    
    func addEvent(_ event: ProjectEvents,to project: Project) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        withAnimation {
            project.addToToHistoryEvent(event.entityObject)
            
            try? viewContext.save()
        }
        
        redraw()
        
    }
    
    func historyEventObjectFromProjectStatus(_ status: Int64) -> HistoryEvent {
            
        let viewContext = PersistenceController.shared.container.viewContext
        
        let event = HistoryEvent(context: viewContext)
        event.cId = UUID()
        event.dateCreated = Date.now
        
        switch status {
        case 1:
            event.type = ProjectEvents.sent.rawValue
        case 2:
            event.type = ProjectEvents.approved.rawValue
        default:
            event.type = ProjectEvents.notSent.rawValue
        }
        
        return event
        
    }
   
}
