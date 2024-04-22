//
//  PricesScreenViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 11/09/2023.
//

import SwiftUI
import CoreData

@MainActor final class PricesScreenViewModel: ObservableObject {
    
    @Published var priceList: PriceList? = nil
    @Published var workDemolitionPrice: String = "0.0"
    @Published var workWiringPrice: String = "0.0"
    @Published var workPlumbingPrice: String = "0.0"
    @Published var workBrickPartitionsPrice: String = "0.0"
    @Published var workBrickLoadBearingWallPrice: String = "0.0"
    @Published var workSimplePlasterboardingPartitionPrice: String = "0.0"
    @Published var workDoublePlasterboardingPartitionPrice: String = "0.0"
    @Published var workTriplePlasterboardingPartitionPrice: String = "0.0"
    @Published var workSimplePlasterboardingOffsetWallPrice: String = "0.0"
    @Published var workDoublePlasterboardingOffsetWallPrice: String = "0.0"
    @Published var workPlasterboardingCeilingPrice: String = "0.0"
    @Published var workNettingWallPrice: String = "0.0"
    @Published var workNettingCeilingPrice: String = "0.0"
    @Published var workPlasteringWallPrice: String = "0.0"
    @Published var workPlasteringCeilingPrice: String = "0.0"
    @Published var workFacadePlastering: String = "0.0"
    @Published var workInstallationOfCornerBeadPrice: String = "0.0"
    @Published var workPlasteringOfWindowSashPrice: String = "0.0"
    @Published var workPenetrationCoatingPrice: String = "0.0"
    @Published var workPaintingWallPrice: String = "0.0"
    @Published var workPaintingCeilingPrice: String = "0.0"
    @Published var workLevellingPrice: String = "0.0"
    @Published var workLayingFloatingFloorsPrice: String = "0.0"
    @Published var workSkirtingOfFloatingFloorPrice: String = "0.0"
    @Published var workTilingCeramicPrice: String = "0.0"
    @Published var workPavingCeramicPrice: String = "0.0"
    @Published var workGroutingPrice: String = "0.0"
    @Published var workSiliconingPrice: String = "0.0"
    @Published var workSanitaryCornerValvePrice: String = "0.0"
    @Published var workSanitaryStandingMixerTapPrice: String = "0.0"
    @Published var workSanitaryWallMountedTapPrice: String = "0.0"
    @Published var workSanitaryFlushMountedTapPrice: String = "0.0"
    @Published var workSanitaryToiletCombiPrice: String = "0.0"
    @Published var workSanitaryToiletWithConcealedCisternPrice: String = "0.0"
    @Published var workSanitarySinkPrice: String = "0.0"
    @Published var workSanitarySinkWithCabinetPrice: String = "0.0"
    @Published var workSanitaryBathtubPrice: String = "0.0"
    @Published var workSanitaryShowerCubiclePrice: String = "0.0"
    @Published var workSanitaryGutterPrice: String = "0.0"
    @Published var workSanitaryUrinal: String = "0.0"
    @Published var workSanitaryBathScreen: String = "0.0"
    @Published var workSanitaryMirror: String = "0.0"
    @Published var workWindowInstallationPrice: String = "0.0"
    @Published var workDoorJambInstallationPrice: String = "0.0"
    @Published var workAuxiliaryAndFinishingPrice: String = "0.0"
    @Published var othersToolRentalPrice: String = "0.0"
    @Published var othersCommutePrice: String = "0.0"
    @Published var othersVatPrice: String = "0.0"
    @Published var materialPartitionMasonryPrice: String = "0.0"
    @Published var materialLoadBearingMasonryPrice: String = "0.0"
    @Published var materialSimplePlasterboardingPartitionPrice: String = "0.0"
    @Published var materialDoublePlasterboardingPartitionPrice: String = "0.0"
    @Published var materialTriplePlasterboardingPartitionPrice: String = "0.0"
    @Published var materialSimplePlasterboardingOffsetWallPrice: String = "0.0"
    @Published var materialDoublePlasterboardingOffsetWallPrice: String = "0.0"
    @Published var materialPlasterboardingCeilingPrice: String = "0.0"
    @Published var materialMeshPrice: String = "0.0"
    @Published var materialAdhesiveNettingPrice: String = "0.0"
    @Published var materialAdhesiveTilingAndPavingPrice: String = "0.0"
    @Published var materialPlasterPrice: String = "0.0"
    @Published var materialCornerBeadPrice: String = "0.0"
    @Published var materialPrimerPrice: String = "0.0"
    @Published var materialPaintWallPrice: String = "0.0"
    @Published var materialPaintCeilingPrice: String = "0.0"
    @Published var materialSelfLevellingCompoundPrice: String = "0.0"
    @Published var materialFloatingFloorPrice: String = "0.0"
    @Published var materialSkirtingBoardPrice: String = "0.0"
    @Published var materialSiliconePrice: String = "0.0"
    @Published var materialTilesPrice: String = "0.0"
    @Published var materialPavingsPrice: String = "0.0"
    @Published var materialAuxiliaryAndFasteningPrice: String = "0.0"
    @Published var materialSimplePlasterboardingPartitionCapacity: String = "0.0"
    @Published var materialDoublePlasterboardingPartitionCapacity: String = "0.0"
    @Published var materialTriplePlasterboardingPartitionCapacity: String = "0.0"
    @Published var materialSimplePlasterboardingOffsetWallCapacity: String = "0.0"
    @Published var materialDoublePlasterboardingOffsetWallCapacity: String = "0.0"
    @Published var materialPlasterboardingCeilingCapacity: String = "0.0"
    @Published var materialAdhesiveNettingCapacity: String = "0.0"
    @Published var materialAdhesiveTilingAndPavingCapacity: String = "0.0"
    @Published var materialPlasterCapacity: String = "0.0"
    @Published var materialFacadePlasterPrice: String = "0.0"
    @Published var materialFacadePlasterCapacity: String = "0.0"
    @Published var materialCornerBeadCapacity: String = "0.0"
    @Published var materialSelfLevellingCompoundCapacity: String = "0.0"
    @Published var materialSiliconeCapacity: String = "0.0"
    
    func doubleToString(from number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
    func stringToDouble(from text: String) -> Double {
        let textWithDot = text.replacingOccurrences(of: ",", with: ".")
        return Double(textWithDot) ?? 0.0
    }
    
    func saveAll() {
        
        let viewContext = PersistenceController.shared.container.viewContext

        if priceList != nil {
            
            priceList?.workDemolitionPrice = stringToDouble(from: workDemolitionPrice)
            priceList?.workWiringPrice = stringToDouble(from: workWiringPrice)
            priceList?.workPlumbingPrice = stringToDouble(from: workPlumbingPrice)
            priceList?.workBrickPartitionsPrice = stringToDouble(from: workBrickPartitionsPrice)
            priceList?.workBrickLoadBearingWallPrice = stringToDouble(from: workBrickLoadBearingWallPrice)
            priceList?.workSimplePlasterboardingPartitionPrice = stringToDouble(from: workSimplePlasterboardingPartitionPrice)
            priceList?.workDoublePlasterboardingPartitionPrice = stringToDouble(from: workDoublePlasterboardingPartitionPrice)
            priceList?.workTriplePlasterboardingPartitionPrice = stringToDouble(from: workTriplePlasterboardingPartitionPrice)
            priceList?.workSimplePlasterboardingOffsetWallPrice = stringToDouble(from: workSimplePlasterboardingOffsetWallPrice)
            priceList?.workDoublePlasterboardingOffsetWallPrice = stringToDouble(from: workDoublePlasterboardingOffsetWallPrice)
            priceList?.workPlasterboardingCeilingPrice = stringToDouble(from: workPlasterboardingCeilingPrice)
            priceList?.workNettingWallPrice = stringToDouble(from: workNettingWallPrice)
            priceList?.workNettingCeilingPrice = stringToDouble(from: workNettingCeilingPrice)
            priceList?.workPlasteringWallPrice = stringToDouble(from: workPlasteringWallPrice)
            priceList?.workPlasteringCeilingPrice = stringToDouble(from: workPlasteringCeilingPrice)
            priceList?.workFacadePlastering = stringToDouble(from: workFacadePlastering)
            priceList?.workInstallationOfCornerBeadPrice = stringToDouble(from: workInstallationOfCornerBeadPrice)
            priceList?.workPlasteringOfWindowSashPrice = stringToDouble(from: workPlasteringOfWindowSashPrice)
            priceList?.workPenetrationCoatingPrice = stringToDouble(from: workPenetrationCoatingPrice)
            priceList?.workPaintingWallPrice = stringToDouble(from: workPaintingWallPrice)
            priceList?.workPaintingCeilingPrice = stringToDouble(from: workPaintingCeilingPrice)
            priceList?.workLevellingPrice = stringToDouble(from: workLevellingPrice)
            priceList?.workLayingFloatingFloorsPrice = stringToDouble(from: workLayingFloatingFloorsPrice)
            priceList?.workSkirtingOfFloatingFloorPrice = stringToDouble(from: workSkirtingOfFloatingFloorPrice)
            priceList?.workTilingCeramicPrice = stringToDouble(from: workTilingCeramicPrice)
            priceList?.workPavingCeramicPrice = stringToDouble(from: workPavingCeramicPrice)
            priceList?.workGroutingPrice = stringToDouble(from: workGroutingPrice)
            priceList?.workSiliconingPrice = stringToDouble(from: workSiliconingPrice)
            priceList?.workSanitaryCornerValvePrice = stringToDouble(from: workSanitaryCornerValvePrice)
            priceList?.workSanitaryStandingMixerTapPrice = stringToDouble(from: workSanitaryStandingMixerTapPrice)
            priceList?.workSanitaryWallMountedTapPrice = stringToDouble(from: workSanitaryWallMountedTapPrice)
            priceList?.workSanitaryFlushMountedTapPrice = stringToDouble(from: workSanitaryFlushMountedTapPrice)
            priceList?.workSanitaryToiletCombiPrice = stringToDouble(from: workSanitaryToiletCombiPrice)
            priceList?.workSanitaryToiletWithConcealedCisternPrice = stringToDouble(from: workSanitaryToiletWithConcealedCisternPrice)
            priceList?.workSanitarySinkPrice = stringToDouble(from: workSanitarySinkPrice)
            priceList?.workSanitarySinkWithCabinetPrice = stringToDouble(from: workSanitarySinkWithCabinetPrice)
            priceList?.workSanitaryBathtubPrice = stringToDouble(from: workSanitaryBathtubPrice)
            priceList?.workSanitaryShowerCubiclePrice = stringToDouble(from: workSanitaryShowerCubiclePrice)
            priceList?.workSanitaryGutterPrice = stringToDouble(from: workSanitaryGutterPrice)
            priceList?.workSanitaryUrinal = stringToDouble(from: workSanitaryUrinal)
            priceList?.workSanitaryBathScreen = stringToDouble(from: workSanitaryBathScreen)
            priceList?.workSanitaryMirror = stringToDouble(from: workSanitaryMirror)
            priceList?.workWindowInstallationPrice = stringToDouble(from: workWindowInstallationPrice)
            priceList?.workDoorJambInstallationPrice = stringToDouble(from: workDoorJambInstallationPrice)
            priceList?.workAuxiliaryAndFinishingPrice = stringToDouble(from: workAuxiliaryAndFinishingPrice)
            priceList?.othersToolRentalPrice = stringToDouble(from: othersToolRentalPrice)
            priceList?.othersCommutePrice = stringToDouble(from: othersCommutePrice)
            priceList?.othersVatPrice = stringToDouble(from: othersVatPrice)
            priceList?.materialPartitionMasonryPrice = stringToDouble(from: materialPartitionMasonryPrice)
            priceList?.materialLoadBearingMasonryPrice = stringToDouble(from: materialLoadBearingMasonryPrice)
            priceList?.materialSimplePlasterboardingPartitionPrice = stringToDouble(from: materialSimplePlasterboardingPartitionPrice)
            priceList?.materialDoublePlasterboardingPartitionPrice = stringToDouble(from: materialDoublePlasterboardingPartitionPrice)
            priceList?.materialTriplePlasterboardingPartitionPrice = stringToDouble(from: materialTriplePlasterboardingPartitionPrice)
            priceList?.materialSimplePlasterboardingOffsetWallPrice = stringToDouble(from: materialSimplePlasterboardingOffsetWallPrice)
            priceList?.materialDoublePlasterboardingOffsetWallPrice = stringToDouble(from: materialDoublePlasterboardingOffsetWallPrice)
            priceList?.materialPlasterboardingCeilingPrice = stringToDouble(from: materialPlasterboardingCeilingPrice)
            priceList?.materialMeshPrice = stringToDouble(from: materialMeshPrice)
            priceList?.materialAdhesiveNettingPrice = stringToDouble(from: materialAdhesiveNettingPrice)
            priceList?.materialAdhesiveTilingAndPavingPrice = stringToDouble(from: materialAdhesiveTilingAndPavingPrice)
            priceList?.materialPlasterPrice = stringToDouble(from: materialPlasterPrice)
            priceList?.materialFacadePlasterPrice = stringToDouble(from: materialFacadePlasterPrice)
            priceList?.materialFacadePlasterCapacity = stringToDouble(from: materialFacadePlasterCapacity)
            priceList?.materialCornerBeadPrice = stringToDouble(from: materialCornerBeadPrice)
            priceList?.materialPrimerPrice = stringToDouble(from: materialPrimerPrice)
            priceList?.materialPaintWallPrice = stringToDouble(from: materialPaintWallPrice)
            priceList?.materialPaintCeilingPrice = stringToDouble(from: materialPaintCeilingPrice)
            priceList?.materialSelfLevellingCompoundPrice = stringToDouble(from: materialSelfLevellingCompoundPrice)
            priceList?.materialFloatingFloorPrice = stringToDouble(from: materialFloatingFloorPrice)
            priceList?.materialSkirtingBoardPrice = stringToDouble(from: materialSkirtingBoardPrice)
            priceList?.materialSiliconePrice = stringToDouble(from: materialSiliconePrice)
            priceList?.materialTilesPrice = stringToDouble(from: materialTilesPrice)
            priceList?.materialPavingsPrice = stringToDouble(from: materialPavingsPrice)
            priceList?.materialAuxiliaryAndFasteningPrice = stringToDouble(from: materialAuxiliaryAndFasteningPrice)
            priceList?.materialSimplePlasterboardingPartitionCapacity = stringToDouble(from: materialSimplePlasterboardingPartitionCapacity)
            priceList?.materialDoublePlasterboardingPartitionCapacity = stringToDouble(from: materialDoublePlasterboardingPartitionCapacity)
            priceList?.materialTriplePlasterboardingPartitionCapacity = stringToDouble(from: materialTriplePlasterboardingPartitionCapacity)
            priceList?.materialSimplePlasterboardingOffsetWallCapacity = stringToDouble(from: materialSimplePlasterboardingOffsetWallCapacity)
            priceList?.materialDoublePlasterboardingOffsetWallCapacity = stringToDouble(from: materialDoublePlasterboardingOffsetWallCapacity)
            priceList?.materialPlasterboardingCeilingCapacity = stringToDouble(from: materialPlasterboardingCeilingCapacity)
            priceList?.materialAdhesiveNettingCapacity = stringToDouble(from: materialAdhesiveNettingCapacity)
            priceList?.materialAdhesiveTilingAndPavingCapacity = stringToDouble(from: materialAdhesiveTilingAndPavingCapacity)
            priceList?.materialPlasterCapacity = stringToDouble(from: materialPlasterCapacity)
            priceList?.materialCornerBeadCapacity = stringToDouble(from: materialCornerBeadCapacity)
            priceList?.materialSelfLevellingCompoundCapacity = stringToDouble(from: materialSelfLevellingCompoundCapacity)
            priceList?.materialSiliconeCapacity = stringToDouble(from: materialSiliconeCapacity)
            
            try? viewContext.save()
            
        }
        
        return
        
    }
    
    func loadPriceList(priceList: PriceList?) {
        
        if let priceList {
            
            workDemolitionPrice = doubleToString(from: priceList.workDemolitionPrice)
            workWiringPrice = doubleToString(from: priceList.workWiringPrice)
            workPlumbingPrice = doubleToString(from: priceList.workPlumbingPrice)
            workBrickPartitionsPrice = doubleToString(from: priceList.workBrickPartitionsPrice)
            workBrickLoadBearingWallPrice = doubleToString(from: priceList.workBrickLoadBearingWallPrice)
            workSimplePlasterboardingPartitionPrice = doubleToString(from: priceList.workSimplePlasterboardingPartitionPrice)
            workDoublePlasterboardingPartitionPrice = doubleToString(from: priceList.workDoublePlasterboardingPartitionPrice)
            workTriplePlasterboardingPartitionPrice = doubleToString(from: priceList.workTriplePlasterboardingPartitionPrice)
            workSimplePlasterboardingOffsetWallPrice = doubleToString(from: priceList.workSimplePlasterboardingOffsetWallPrice)
            workDoublePlasterboardingOffsetWallPrice = doubleToString(from: priceList.workDoublePlasterboardingOffsetWallPrice)
            workPlasterboardingCeilingPrice = doubleToString(from: priceList.workPlasterboardingCeilingPrice)
            workNettingWallPrice = doubleToString(from: priceList.workNettingWallPrice)
            workNettingCeilingPrice = doubleToString(from: priceList.workNettingCeilingPrice)
            workPlasteringWallPrice = doubleToString(from: priceList.workPlasteringWallPrice)
            workPlasteringCeilingPrice = doubleToString(from: priceList.workPlasteringCeilingPrice)
            workFacadePlastering = doubleToString(from: priceList.workFacadePlastering)
            workInstallationOfCornerBeadPrice = doubleToString(from: priceList.workInstallationOfCornerBeadPrice)
            workPlasteringOfWindowSashPrice = doubleToString(from: priceList.workPlasteringOfWindowSashPrice)
            workPenetrationCoatingPrice = doubleToString(from: priceList.workPenetrationCoatingPrice)
            workPaintingWallPrice = doubleToString(from: priceList.workPaintingWallPrice)
            workPaintingCeilingPrice = doubleToString(from: priceList.workPaintingCeilingPrice)
            workLevellingPrice = doubleToString(from: priceList.workLevellingPrice)
            workLayingFloatingFloorsPrice = doubleToString(from: priceList.workLayingFloatingFloorsPrice)
            workSkirtingOfFloatingFloorPrice = doubleToString(from: priceList.workSkirtingOfFloatingFloorPrice)
            workTilingCeramicPrice = doubleToString(from: priceList.workTilingCeramicPrice)
            workPavingCeramicPrice = doubleToString(from: priceList.workPavingCeramicPrice)
            workGroutingPrice = doubleToString(from: priceList.workGroutingPrice)
            workSiliconingPrice = doubleToString(from: priceList.workSiliconingPrice)
            workSanitaryCornerValvePrice = doubleToString(from: priceList.workSanitaryCornerValvePrice)
            workSanitaryStandingMixerTapPrice = doubleToString(from: priceList.workSanitaryStandingMixerTapPrice)
            workSanitaryWallMountedTapPrice = doubleToString(from: priceList.workSanitaryWallMountedTapPrice)
            workSanitaryFlushMountedTapPrice = doubleToString(from: priceList.workSanitaryFlushMountedTapPrice)
            workSanitaryToiletCombiPrice = doubleToString(from: priceList.workSanitaryToiletCombiPrice)
            workSanitaryToiletWithConcealedCisternPrice = doubleToString(from: priceList.workSanitaryToiletWithConcealedCisternPrice)
            workSanitarySinkPrice = doubleToString(from: priceList.workSanitarySinkPrice)
            workSanitarySinkWithCabinetPrice = doubleToString(from: priceList.workSanitarySinkWithCabinetPrice)
            workSanitaryBathtubPrice = doubleToString(from: priceList.workSanitaryBathtubPrice)
            workSanitaryShowerCubiclePrice = doubleToString(from: priceList.workSanitaryShowerCubiclePrice)
            workSanitaryGutterPrice = doubleToString(from: priceList.workSanitaryGutterPrice)
            workSanitaryUrinal = doubleToString(from: priceList.workSanitaryUrinal)
            workSanitaryBathScreen = doubleToString(from: priceList.workSanitaryBathScreen)
            workSanitaryMirror = doubleToString(from: priceList.workSanitaryMirror)
            workWindowInstallationPrice = doubleToString(from: priceList.workWindowInstallationPrice)
            workDoorJambInstallationPrice = doubleToString(from: priceList.workDoorJambInstallationPrice)
            workAuxiliaryAndFinishingPrice = doubleToString(from: priceList.workAuxiliaryAndFinishingPrice)
            othersToolRentalPrice = doubleToString(from: priceList.othersToolRentalPrice)
            othersCommutePrice = doubleToString(from: priceList.othersCommutePrice)
            othersVatPrice = doubleToString(from: priceList.othersVatPrice)
            materialPartitionMasonryPrice = doubleToString(from: priceList.materialPartitionMasonryPrice)
            materialLoadBearingMasonryPrice = doubleToString(from: priceList.materialLoadBearingMasonryPrice)
            materialSimplePlasterboardingPartitionPrice = doubleToString(from: priceList.materialSimplePlasterboardingPartitionPrice)
            materialDoublePlasterboardingPartitionPrice = doubleToString(from: priceList.materialDoublePlasterboardingPartitionPrice)
            materialTriplePlasterboardingPartitionPrice = doubleToString(from: priceList.materialTriplePlasterboardingPartitionPrice)
            materialSimplePlasterboardingOffsetWallPrice = doubleToString(from: priceList.materialSimplePlasterboardingOffsetWallPrice)
            materialDoublePlasterboardingOffsetWallPrice = doubleToString(from: priceList.materialDoublePlasterboardingOffsetWallPrice)
            materialPlasterboardingCeilingPrice = doubleToString(from: priceList.materialPlasterboardingCeilingPrice)
            materialMeshPrice = doubleToString(from: priceList.materialMeshPrice)
            materialAdhesiveNettingPrice = doubleToString(from: priceList.materialAdhesiveNettingPrice)
            materialAdhesiveTilingAndPavingPrice = doubleToString(from: priceList.materialAdhesiveTilingAndPavingPrice)
            materialPlasterPrice = doubleToString(from: priceList.materialPlasterPrice)
            materialFacadePlasterPrice = doubleToString(from: priceList.materialFacadePlasterPrice)
            materialFacadePlasterCapacity = doubleToString(from: priceList.materialFacadePlasterCapacity)
            materialCornerBeadPrice = doubleToString(from: priceList.materialCornerBeadPrice)
            materialPrimerPrice = doubleToString(from: priceList.materialPrimerPrice)
            materialPaintWallPrice = doubleToString(from: priceList.materialPaintWallPrice)
            materialPaintCeilingPrice = doubleToString(from: priceList.materialPaintCeilingPrice)
            materialSelfLevellingCompoundPrice = doubleToString(from: priceList.materialSelfLevellingCompoundPrice)
            materialFloatingFloorPrice = doubleToString(from: priceList.materialFloatingFloorPrice)
            materialSkirtingBoardPrice = doubleToString(from: priceList.materialSkirtingBoardPrice)
            materialSiliconePrice = doubleToString(from: priceList.materialSiliconePrice)
            materialTilesPrice = doubleToString(from: priceList.materialTilesPrice)
            materialPavingsPrice = doubleToString(from: priceList.materialPavingsPrice)
            materialAuxiliaryAndFasteningPrice = doubleToString(from: priceList.materialAuxiliaryAndFasteningPrice)
            materialSimplePlasterboardingPartitionCapacity = doubleToString(from: priceList.materialSimplePlasterboardingPartitionCapacity)
            materialDoublePlasterboardingPartitionCapacity = doubleToString(from: priceList.materialDoublePlasterboardingPartitionCapacity)
            materialTriplePlasterboardingPartitionCapacity = doubleToString(from: priceList.materialTriplePlasterboardingPartitionCapacity)
            materialSimplePlasterboardingOffsetWallCapacity = doubleToString(from: priceList.materialSimplePlasterboardingOffsetWallCapacity)
            materialDoublePlasterboardingOffsetWallCapacity = doubleToString(from: priceList.materialDoublePlasterboardingOffsetWallCapacity)
            materialPlasterboardingCeilingCapacity = doubleToString(from: priceList.materialPlasterboardingCeilingCapacity)
            materialAdhesiveNettingCapacity = doubleToString(from: priceList.materialAdhesiveNettingCapacity)
            materialAdhesiveTilingAndPavingCapacity = doubleToString(from: priceList.materialAdhesiveTilingAndPavingCapacity)
            materialPlasterCapacity = doubleToString(from: priceList.materialPlasterCapacity)
            materialCornerBeadCapacity = doubleToString(from: priceList.materialCornerBeadCapacity)
            materialSelfLevellingCompoundCapacity = doubleToString(from: priceList.materialSelfLevellingCompoundCapacity)
            materialSiliconeCapacity = doubleToString(from: priceList.materialSiliconeCapacity)
            
        }
    }
    
}
