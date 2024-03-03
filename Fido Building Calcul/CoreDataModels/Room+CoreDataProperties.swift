//
//  Room+CoreDataProperties.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var name: String?
    @NSManaged public var containsBricklayingOfLoadBearingMasonry: NSSet?
    @NSManaged public var containsBricklayingOfPartitions: NSSet?
    @NSManaged public var containsDemolitionWork: NSSet?
    @NSManaged public var containsElectricalInstallationWork: NSSet?
    @NSManaged public var containsFloatingFloorLaying: NSSet?
    @NSManaged public var containsGroutingTilesAndPaving: NSSet?
    @NSManaged public var containsInstallationOfCornerStrip: NSSet?
    @NSManaged public var containsInstallationOfLinedDoorFrame: NSSet?
    @NSManaged public var containsInstallationOfSanitaryWare: NSSet?
    @NSManaged public var containsLevelling: NSSet?
    @NSManaged public var containsNettingCeiling: NSSet?
    @NSManaged public var containsNettingWall: NSSet?
    @NSManaged public var containsPaintingCeiling: NSSet?
    @NSManaged public var containsPaintingWall: NSSet?
    @NSManaged public var containsPavingCeramic: NSSet?
    @NSManaged public var containsPenetrationCoat: NSSet?
    @NSManaged public var containsPlasterboardCeiling: NSSet?
    @NSManaged public var containsPlasterboardPartition: NSSet?
    @NSManaged public var containsPlasteringCeiling: NSSet?
    @NSManaged public var containsPlasteringOfReveal: NSSet?
    @NSManaged public var containsPlasteringWall: NSSet?
    @NSManaged public var containsPlumbingWork: NSSet?
    @NSManaged public var containsSkirtingFloatingFloor: NSSet?
    @NSManaged public var containsTileCeramic: NSSet?
    @NSManaged public var containsWindowInstallation: NSSet?
    @NSManaged public var fromProject: Project?

}

// MARK: Generated accessors for containsBricklayingOfLoadBearingMasonry
extension Room {

    @objc(addContainsBricklayingOfLoadBearingMasonryObject:)
    @NSManaged public func addToContainsBricklayingOfLoadBearingMasonry(_ value: BricklayingOfLoadBearingMasonry)

    @objc(removeContainsBricklayingOfLoadBearingMasonryObject:)
    @NSManaged public func removeFromContainsBricklayingOfLoadBearingMasonry(_ value: BricklayingOfLoadBearingMasonry)

    @objc(addContainsBricklayingOfLoadBearingMasonry:)
    @NSManaged public func addToContainsBricklayingOfLoadBearingMasonry(_ values: NSSet)

    @objc(removeContainsBricklayingOfLoadBearingMasonry:)
    @NSManaged public func removeFromContainsBricklayingOfLoadBearingMasonry(_ values: NSSet)

}

// MARK: Generated accessors for containsBricklayingOfPartitions
extension Room {

    @objc(addContainsBricklayingOfPartitionsObject:)
    @NSManaged public func addToContainsBricklayingOfPartitions(_ value: BricklayingOfPartitions)

    @objc(removeContainsBricklayingOfPartitionsObject:)
    @NSManaged public func removeFromContainsBricklayingOfPartitions(_ value: BricklayingOfPartitions)

    @objc(addContainsBricklayingOfPartitions:)
    @NSManaged public func addToContainsBricklayingOfPartitions(_ values: NSSet)

    @objc(removeContainsBricklayingOfPartitions:)
    @NSManaged public func removeFromContainsBricklayingOfPartitions(_ values: NSSet)

}

// MARK: Generated accessors for containsDemolitionWork
extension Room {

    @objc(addContainsDemolitionWorkObject:)
    @NSManaged public func addToContainsDemolitionWork(_ value: DemolitionWork)

    @objc(removeContainsDemolitionWorkObject:)
    @NSManaged public func removeFromContainsDemolitionWork(_ value: DemolitionWork)

    @objc(addContainsDemolitionWork:)
    @NSManaged public func addToContainsDemolitionWork(_ values: NSSet)

    @objc(removeContainsDemolitionWork:)
    @NSManaged public func removeFromContainsDemolitionWork(_ values: NSSet)

}

// MARK: Generated accessors for containsElectricalInstallationWork
extension Room {

    @objc(addContainsElectricalInstallationWorkObject:)
    @NSManaged public func addToContainsElectricalInstallationWork(_ value: ElectricalInstallationWork)

    @objc(removeContainsElectricalInstallationWorkObject:)
    @NSManaged public func removeFromContainsElectricalInstallationWork(_ value: ElectricalInstallationWork)

    @objc(addContainsElectricalInstallationWork:)
    @NSManaged public func addToContainsElectricalInstallationWork(_ values: NSSet)

    @objc(removeContainsElectricalInstallationWork:)
    @NSManaged public func removeFromContainsElectricalInstallationWork(_ values: NSSet)

}

// MARK: Generated accessors for containsFloatingFloorLaying
extension Room {

    @objc(addContainsFloatingFloorLayingObject:)
    @NSManaged public func addToContainsFloatingFloorLaying(_ value: FloatingFloorLaying)

    @objc(removeContainsFloatingFloorLayingObject:)
    @NSManaged public func removeFromContainsFloatingFloorLaying(_ value: FloatingFloorLaying)

    @objc(addContainsFloatingFloorLaying:)
    @NSManaged public func addToContainsFloatingFloorLaying(_ values: NSSet)

    @objc(removeContainsFloatingFloorLaying:)
    @NSManaged public func removeFromContainsFloatingFloorLaying(_ values: NSSet)

}

// MARK: Generated accessors for containsGroutingTilesAndPaving
extension Room {

    @objc(addContainsGroutingTilesAndPavingObject:)
    @NSManaged public func addToContainsGroutingTilesAndPaving(_ value: GroutingTilesAndPaving)

    @objc(removeContainsGroutingTilesAndPavingObject:)
    @NSManaged public func removeFromContainsGroutingTilesAndPaving(_ value: GroutingTilesAndPaving)

    @objc(addContainsGroutingTilesAndPaving:)
    @NSManaged public func addToContainsGroutingTilesAndPaving(_ values: NSSet)

    @objc(removeContainsGroutingTilesAndPaving:)
    @NSManaged public func removeFromContainsGroutingTilesAndPaving(_ values: NSSet)

}

// MARK: Generated accessors for containsInstallationOfCornerStrip
extension Room {

    @objc(addContainsInstallationOfCornerStripObject:)
    @NSManaged public func addToContainsInstallationOfCornerStrip(_ value: InstallationOfCornerStrip)

    @objc(removeContainsInstallationOfCornerStripObject:)
    @NSManaged public func removeFromContainsInstallationOfCornerStrip(_ value: InstallationOfCornerStrip)

    @objc(addContainsInstallationOfCornerStrip:)
    @NSManaged public func addToContainsInstallationOfCornerStrip(_ values: NSSet)

    @objc(removeContainsInstallationOfCornerStrip:)
    @NSManaged public func removeFromContainsInstallationOfCornerStrip(_ values: NSSet)

}

// MARK: Generated accessors for containsInstallationOfLinedDoorFrame
extension Room {

    @objc(addContainsInstallationOfLinedDoorFrameObject:)
    @NSManaged public func addToContainsInstallationOfLinedDoorFrame(_ value: InstallationOfLinedDoorFrame)

    @objc(removeContainsInstallationOfLinedDoorFrameObject:)
    @NSManaged public func removeFromContainsInstallationOfLinedDoorFrame(_ value: InstallationOfLinedDoorFrame)

    @objc(addContainsInstallationOfLinedDoorFrame:)
    @NSManaged public func addToContainsInstallationOfLinedDoorFrame(_ values: NSSet)

    @objc(removeContainsInstallationOfLinedDoorFrame:)
    @NSManaged public func removeFromContainsInstallationOfLinedDoorFrame(_ values: NSSet)

}

// MARK: Generated accessors for containsInstallationOfSanitaryWare
extension Room {

    @objc(addContainsInstallationOfSanitaryWareObject:)
    @NSManaged public func addToContainsInstallationOfSanitaryWare(_ value: InstallationOfSanitaryWare)

    @objc(removeContainsInstallationOfSanitaryWareObject:)
    @NSManaged public func removeFromContainsInstallationOfSanitaryWare(_ value: InstallationOfSanitaryWare)

    @objc(addContainsInstallationOfSanitaryWare:)
    @NSManaged public func addToContainsInstallationOfSanitaryWare(_ values: NSSet)

    @objc(removeContainsInstallationOfSanitaryWare:)
    @NSManaged public func removeFromContainsInstallationOfSanitaryWare(_ values: NSSet)

}

// MARK: Generated accessors for containsLevelling
extension Room {

    @objc(addContainsLevellingObject:)
    @NSManaged public func addToContainsLevelling(_ value: Levelling)

    @objc(removeContainsLevellingObject:)
    @NSManaged public func removeFromContainsLevelling(_ value: Levelling)

    @objc(addContainsLevelling:)
    @NSManaged public func addToContainsLevelling(_ values: NSSet)

    @objc(removeContainsLevelling:)
    @NSManaged public func removeFromContainsLevelling(_ values: NSSet)

}

// MARK: Generated accessors for containsNettingCeiling
extension Room {

    @objc(addContainsNettingCeilingObject:)
    @NSManaged public func addToContainsNettingCeiling(_ value: NettingCeiling)

    @objc(removeContainsNettingCeilingObject:)
    @NSManaged public func removeFromContainsNettingCeiling(_ value: NettingCeiling)

    @objc(addContainsNettingCeiling:)
    @NSManaged public func addToContainsNettingCeiling(_ values: NSSet)

    @objc(removeContainsNettingCeiling:)
    @NSManaged public func removeFromContainsNettingCeiling(_ values: NSSet)

}

// MARK: Generated accessors for containsNettingWall
extension Room {

    @objc(addContainsNettingWallObject:)
    @NSManaged public func addToContainsNettingWall(_ value: NettingWall)

    @objc(removeContainsNettingWallObject:)
    @NSManaged public func removeFromContainsNettingWall(_ value: NettingWall)

    @objc(addContainsNettingWall:)
    @NSManaged public func addToContainsNettingWall(_ values: NSSet)

    @objc(removeContainsNettingWall:)
    @NSManaged public func removeFromContainsNettingWall(_ values: NSSet)

}

// MARK: Generated accessors for containsPaintingCeiling
extension Room {

    @objc(addContainsPaintingCeilingObject:)
    @NSManaged public func addToContainsPaintingCeiling(_ value: PaintingCeiling)

    @objc(removeContainsPaintingCeilingObject:)
    @NSManaged public func removeFromContainsPaintingCeiling(_ value: PaintingCeiling)

    @objc(addContainsPaintingCeiling:)
    @NSManaged public func addToContainsPaintingCeiling(_ values: NSSet)

    @objc(removeContainsPaintingCeiling:)
    @NSManaged public func removeFromContainsPaintingCeiling(_ values: NSSet)

}

// MARK: Generated accessors for containsPaintingWall
extension Room {

    @objc(addContainsPaintingWallObject:)
    @NSManaged public func addToContainsPaintingWall(_ value: PaintingWall)

    @objc(removeContainsPaintingWallObject:)
    @NSManaged public func removeFromContainsPaintingWall(_ value: PaintingWall)

    @objc(addContainsPaintingWall:)
    @NSManaged public func addToContainsPaintingWall(_ values: NSSet)

    @objc(removeContainsPaintingWall:)
    @NSManaged public func removeFromContainsPaintingWall(_ values: NSSet)

}

// MARK: Generated accessors for containsPavingCeramic
extension Room {

    @objc(addContainsPavingCeramicObject:)
    @NSManaged public func addToContainsPavingCeramic(_ value: PavingCeramic)

    @objc(removeContainsPavingCeramicObject:)
    @NSManaged public func removeFromContainsPavingCeramic(_ value: PavingCeramic)

    @objc(addContainsPavingCeramic:)
    @NSManaged public func addToContainsPavingCeramic(_ values: NSSet)

    @objc(removeContainsPavingCeramic:)
    @NSManaged public func removeFromContainsPavingCeramic(_ values: NSSet)

}

// MARK: Generated accessors for containsPenetrationCoat
extension Room {

    @objc(addContainsPenetrationCoatObject:)
    @NSManaged public func addToContainsPenetrationCoat(_ value: PenetrationCoat)

    @objc(removeContainsPenetrationCoatObject:)
    @NSManaged public func removeFromContainsPenetrationCoat(_ value: PenetrationCoat)

    @objc(addContainsPenetrationCoat:)
    @NSManaged public func addToContainsPenetrationCoat(_ values: NSSet)

    @objc(removeContainsPenetrationCoat:)
    @NSManaged public func removeFromContainsPenetrationCoat(_ values: NSSet)

}

// MARK: Generated accessors for containsPlasterboardCeiling
extension Room {

    @objc(addContainsPlasterboardCeilingObject:)
    @NSManaged public func addToContainsPlasterboardCeiling(_ value: PlasterboardCeiling)

    @objc(removeContainsPlasterboardCeilingObject:)
    @NSManaged public func removeFromContainsPlasterboardCeiling(_ value: PlasterboardCeiling)

    @objc(addContainsPlasterboardCeiling:)
    @NSManaged public func addToContainsPlasterboardCeiling(_ values: NSSet)

    @objc(removeContainsPlasterboardCeiling:)
    @NSManaged public func removeFromContainsPlasterboardCeiling(_ values: NSSet)

}

// MARK: Generated accessors for containsPlasterboardPartition
extension Room {

    @objc(addContainsPlasterboardPartitionObject:)
    @NSManaged public func addToContainsPlasterboardPartition(_ value: PlasterboardPartition)

    @objc(removeContainsPlasterboardPartitionObject:)
    @NSManaged public func removeFromContainsPlasterboardPartition(_ value: PlasterboardPartition)

    @objc(addContainsPlasterboardPartition:)
    @NSManaged public func addToContainsPlasterboardPartition(_ values: NSSet)

    @objc(removeContainsPlasterboardPartition:)
    @NSManaged public func removeFromContainsPlasterboardPartition(_ values: NSSet)

}

// MARK: Generated accessors for containsPlasteringCeiling
extension Room {

    @objc(addContainsPlasteringCeilingObject:)
    @NSManaged public func addToContainsPlasteringCeiling(_ value: PlasteringCeiling)

    @objc(removeContainsPlasteringCeilingObject:)
    @NSManaged public func removeFromContainsPlasteringCeiling(_ value: PlasteringCeiling)

    @objc(addContainsPlasteringCeiling:)
    @NSManaged public func addToContainsPlasteringCeiling(_ values: NSSet)

    @objc(removeContainsPlasteringCeiling:)
    @NSManaged public func removeFromContainsPlasteringCeiling(_ values: NSSet)

}

// MARK: Generated accessors for containsPlasteringOfReveal
extension Room {

    @objc(addContainsPlasteringOfRevealObject:)
    @NSManaged public func addToContainsPlasteringOfReveal(_ value: PlasteringOfReveal)

    @objc(removeContainsPlasteringOfRevealObject:)
    @NSManaged public func removeFromContainsPlasteringOfReveal(_ value: PlasteringOfReveal)

    @objc(addContainsPlasteringOfReveal:)
    @NSManaged public func addToContainsPlasteringOfReveal(_ values: NSSet)

    @objc(removeContainsPlasteringOfReveal:)
    @NSManaged public func removeFromContainsPlasteringOfReveal(_ values: NSSet)

}

// MARK: Generated accessors for containsPlasteringWall
extension Room {

    @objc(addContainsPlasteringWallObject:)
    @NSManaged public func addToContainsPlasteringWall(_ value: PlasteringWall)

    @objc(removeContainsPlasteringWallObject:)
    @NSManaged public func removeFromContainsPlasteringWall(_ value: PlasteringWall)

    @objc(addContainsPlasteringWall:)
    @NSManaged public func addToContainsPlasteringWall(_ values: NSSet)

    @objc(removeContainsPlasteringWall:)
    @NSManaged public func removeFromContainsPlasteringWall(_ values: NSSet)

}

// MARK: Generated accessors for containsPlumbingWork
extension Room {

    @objc(addContainsPlumbingWorkObject:)
    @NSManaged public func addToContainsPlumbingWork(_ value: PlumbingWork)

    @objc(removeContainsPlumbingWorkObject:)
    @NSManaged public func removeFromContainsPlumbingWork(_ value: PlumbingWork)

    @objc(addContainsPlumbingWork:)
    @NSManaged public func addToContainsPlumbingWork(_ values: NSSet)

    @objc(removeContainsPlumbingWork:)
    @NSManaged public func removeFromContainsPlumbingWork(_ values: NSSet)

}

// MARK: Generated accessors for containsSkirtingFloatingFloor
extension Room {

    @objc(addContainsSkirtingFloatingFloorObject:)
    @NSManaged public func addToContainsSkirtingFloatingFloor(_ value: SkirtingFloatingFloor)

    @objc(removeContainsSkirtingFloatingFloorObject:)
    @NSManaged public func removeFromContainsSkirtingFloatingFloor(_ value: SkirtingFloatingFloor)

    @objc(addContainsSkirtingFloatingFloor:)
    @NSManaged public func addToContainsSkirtingFloatingFloor(_ values: NSSet)

    @objc(removeContainsSkirtingFloatingFloor:)
    @NSManaged public func removeFromContainsSkirtingFloatingFloor(_ values: NSSet)

}

// MARK: Generated accessors for containsTileCeramic
extension Room {

    @objc(addContainsTileCeramicObject:)
    @NSManaged public func addToContainsTileCeramic(_ value: TileCeramic)

    @objc(removeContainsTileCeramicObject:)
    @NSManaged public func removeFromContainsTileCeramic(_ value: TileCeramic)

    @objc(addContainsTileCeramic:)
    @NSManaged public func addToContainsTileCeramic(_ values: NSSet)

    @objc(removeContainsTileCeramic:)
    @NSManaged public func removeFromContainsTileCeramic(_ values: NSSet)

}

// MARK: Generated accessors for containsWindowInstallation
extension Room {

    @objc(addContainsWindowInstallationObject:)
    @NSManaged public func addToContainsWindowInstallation(_ value: WindowInstallation)

    @objc(removeContainsWindowInstallationObject:)
    @NSManaged public func removeFromContainsWindowInstallation(_ value: WindowInstallation)

    @objc(addContainsWindowInstallation:)
    @NSManaged public func addToContainsWindowInstallation(_ values: NSSet)

    @objc(removeContainsWindowInstallation:)
    @NSManaged public func removeFromContainsWindowInstallation(_ values: NSSet)

}

extension Room : Identifiable {

}
