//
//  PriceList+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//

import Foundation
import CoreData


extension PriceList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PriceList> {
        return NSFetchRequest<PriceList>(entityName: "PriceList")
    }

    @NSManaged public var cId: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateEdited: Date?
    @NSManaged public var isGeneral: Bool
    @NSManaged public var workDemolitionPrice: Double
    @NSManaged public var workWiringPrice: Double
    @NSManaged public var workPlumbingPrice: Double
    @NSManaged public var workBrickPartitionsPrice: Double
    @NSManaged public var workBrickLoadBearingWallPrice: Double
    @NSManaged public var workSimplePlasterboardingPartitionPrice: Double
    @NSManaged public var workDoublePlasterboardingPartitionPrice: Double
    @NSManaged public var workTriplePlasterboardingPartitionPrice: Double
    @NSManaged public var workPlasterboardingCeilingPrice: Double
    @NSManaged public var workNettingWallPrice: Double
    @NSManaged public var workNettingCeilingPrice: Double
    @NSManaged public var workPlasteringWallPrice: Double
    @NSManaged public var workPlasteringCeilingPrice: Double
    @NSManaged public var workInstallationOfCornerBeadPrice: Double
    @NSManaged public var workPlasteringOfWindowSashPrice: Double
    @NSManaged public var workPenetrationCoatingPrice: Double
    @NSManaged public var workPaintingWallPrice: Double
    @NSManaged public var workPaintingCeilingPrice: Double
    @NSManaged public var workLevellingPrice: Double
    @NSManaged public var workLayingFloatingFloorsPrice: Double
    @NSManaged public var workSkirtingOfFloatingFloorPrice: Double
    @NSManaged public var workTilingCeramicPrice: Double
    @NSManaged public var workPavingCeramicPrice: Double
    @NSManaged public var workGroutingPrice: Double
    @NSManaged public var workSiliconingPrice: Double
    @NSManaged public var workSanitaryCornerValvePrice: Double
    @NSManaged public var workSanitaryStandingMixerTapPrice: Double
    @NSManaged public var workSanitaryWallMountedTapPrice: Double
    @NSManaged public var workSanitaryFlushMountedTapPrice: Double
    @NSManaged public var workSanitaryToiletCombiPrice: Double
    @NSManaged public var workSanitaryToiletWithConcealedCisternPrice: Double
    @NSManaged public var workSanitarySinkPrice: Double
    @NSManaged public var workSanitarySinkWithCabinetPrice: Double
    @NSManaged public var workSanitaryBathtubPrice: Double
    @NSManaged public var workSanitaryShowerCubiclePrice: Double
    @NSManaged public var workSanitaryGutterPrice: Double
    @NSManaged public var workWindowInstallationPrice: Double
    @NSManaged public var workDoorJambInstallationPrice: Double
    @NSManaged public var workAuxiliaryAndFinishingPrice: Double
    @NSManaged public var othersToolRentalPrice: Double
    @NSManaged public var othersCommutePrice: Double
    @NSManaged public var othersVatPrice: Double
    @NSManaged public var materialPartitionMasonryPrice: Double
    @NSManaged public var materialLoadBearingMasonryPrice: Double
    @NSManaged public var materialPlasterboardPartitionPrice: Double
    @NSManaged public var materialPlasterboardCeilingPrice: Double
    @NSManaged public var materialMeshPrice: Double
    @NSManaged public var materialAdhesiveNettingPrice: Double
    @NSManaged public var materialAdhesiveTilingAndPavingPrice: Double
    @NSManaged public var materialPlasterPrice: Double
    @NSManaged public var materialCornerBeadPrice: Double
    @NSManaged public var materialPrimerPrice: Double
    @NSManaged public var materialPaintWallPrice: Double
    @NSManaged public var materialPaintCeilingPrice: Double
    @NSManaged public var materialSelfLevellingCompoundPrice: Double
    @NSManaged public var materialFloatingFloorPrice: Double
    @NSManaged public var materialSkirtingBoardPrice: Double
    @NSManaged public var materialSiliconePrice: Double
    @NSManaged public var materialTilesPrice: Double
    @NSManaged public var materialPavingsPrice: Double
    @NSManaged public var materialAuxiliaryAndFasteningPrice: Double
    @NSManaged public var materialPlasterboardPartitionCapacity: Double
    @NSManaged public var materialPlasterboardCeilingCapacity: Double
    @NSManaged public var materialAdhesiveNettingCapacity: Double
    @NSManaged public var materialAdhesiveTilingAndPavingCapacity: Double
    @NSManaged public var materialPlasterCapacity: Double
    @NSManaged public var materialCornerBeadCapacity: Double
    @NSManaged public var materialSelfLevellingCompoundCapacity: Double
    @NSManaged public var materialSiliconeCapacity: Double
    @NSManaged public var fromProject: Project?

}

extension PriceList : Identifiable {

}
