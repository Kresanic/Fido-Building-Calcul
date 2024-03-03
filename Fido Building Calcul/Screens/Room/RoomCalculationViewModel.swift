//
//  RoomCalculationViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI
import CoreData

@MainActor final class RoomCalculationViewModel: ObservableObject {
    
    // MARK: - Work
    @AppStorage("demolitionWork") var demolitionWork: Double = 15.00
    @AppStorage("electricalWork") var electricalWork: Double = 20.00
    @AppStorage("plumbingWorkExtraction") var plumbingWorkExtraction: Double = 45.00
    @AppStorage("masonryPartitionWall") var masonryPartitionWall: Double = 18.00
    @AppStorage("masonryLoadbearingWall") var masonryLoadbearingWall: Double = 55.00
    @AppStorage("drywallCeiling") var drywallCeiling: Double = 30.00
    @AppStorage("drywallPartitionTwoLayers") var drywallPartitionTwoLayers: Double = 45.00
    @AppStorage("plasterMeshWall") var plasterMeshWall: Double = 5.00
    @AppStorage("plasterMeshCeiling") var plasterMeshCeiling: Double = 8.00
    @AppStorage("plasteringWall") var plasteringWall: Double = 7.00
    @AppStorage("plasteringCeiling") var plasteringCeiling: Double = 10.00
    @AppStorage("cornerMoldingInstallation") var cornerMoldingInstallation: Double = 3.00
    @AppStorage("windowJambPlastering") var windowJambPlastering: Double = 5.00
    @AppStorage("primingPaint") var primingPaint: Double = 1.00
    @AppStorage("wallPaintingTwoLayers") var wallPaintingTwoLayers: Double = 2.50
    @AppStorage("ceilingPaintingTwoLayers") var ceilingPaintingTwoLayers: Double = 3.00
    @AppStorage("leveling") var leveling: Double = 7.00
    @AppStorage("floatingFloorInstallation") var floatingFloorInstallation: Double = 6.00
    @AppStorage("floatingFloorMolding") var floatingFloorMolding: Double = 3.50
    @AppStorage("ceramicTileWall") var ceramicTileWall: Double = 30.00
    @AppStorage("ceramicTileFloor") var ceramicTileFloor: Double = 30.00
    @AppStorage("groutingTile") var groutingTile: Double = 5.00
    @AppStorage("sanitaryInstallation") var sanitaryInstallation: Double = 35.00
    @AppStorage("windowInstallation") var windowInstallation: Double = 7.00
    @AppStorage("doorFrameInstallation") var doorFrameInstallation: Double = 55.00
    @AppStorage("auxiliaryFinishingWork") var auxiliaryFinishingWork: Double = 10
    
    // MARK: - Material
    @AppStorage("partitionWall") var partitionWall: Double = 30.00
    @AppStorage("loadbearingWall") var loadbearingWall: Double = 160.00
    @AppStorage("drywallCeilingMaterials") var drywallCeilingMaterials: Double = 20.00
    @AppStorage("drywallPartitionMaterials") var drywallPartitionMaterials: Double = 35.00
    @AppStorage("fiberglassMesh") var fiberglassMesh: Double = 1.30
    @AppStorage("adhesive") var adhesive: Double = 12.00
    @AppStorage("plaster") var plaster: Double = 13.00
    @AppStorage("cornerMolding") var cornerMolding: Double = 4.50
    @AppStorage("primer") var primer: Double = 0.50
    @AppStorage("wallPaint") var wallPaint: Double = 0.80
    @AppStorage("ceilingPaint") var ceilingPaint: Double = 0.80
    @AppStorage("selfLevelingCompound") var selfLevelingCompound: Double = 18.00
    @AppStorage("floatingFloor") var floatingFloor: Double = 15.00
    @AppStorage("baseboardMolding") var baseboardMolding: Double = 3.00
    @AppStorage("wallTile") var wallTile: Double = 20.00
    @AppStorage("floorTile") var floorTile: Double = 20.00
    @AppStorage("auxiliaryConnectingMaterial") var auxiliaryConnectingMaterial: Double = 10
    
    
    func demolitionWorkPrice(room: Room) -> Double {
        
        let price = Double(room.associatedDemolitions.reduce(0, { $0 + Int($1.hours)})) * demolitionWork
        
        return price
        
    }
    
    func electricalWorkPrice(room: Room) -> Double {
        
        let price = Double(room.associatedElectricalWorks.reduce(0, { $0 + Int($1.hours)})) * electricalWork
        
        return price
        
    }
    
    func plumbingWorkPrice(room: Room) -> Double {
        
        let price = Double(room.associatedPlumbingWorks.reduce(0, { $0 + Int($1.pieces)})) * plumbingWorkExtraction
        
        return price
        
    }
    
    func layingPartitionWallPrice(room: Room) -> Double {
        
        let area = room.associatedBricklayingOfPartitions.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedBricklayingOfPartitions {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * masonryPartitionWall
        
    }
    
    func layingLoadBearingWallPrice(room: Room) -> Double {
        
        let area = room.associatedBricklayingOfLoadBearingWalls.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedBricklayingOfLoadBearingWalls {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * masonryLoadbearingWall
        
    }
    
    func plasterboardCeilingPrice(room: Room) -> Double {
        
        let area = room.associatedPlasterboardCeilings.reduce(0, { $0 + Int($1.length * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedPlasterboardCeilings {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * drywallCeiling
        
        
    }
    
    func plasterboardPartitionPrice(room: Room) -> Double {
        
        let area = room.associatedPlasterboardPartitions.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedPlasterboardPartitions {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * drywallPartitionTwoLayers
        
    }
    
    func nettingWallPrice(room: Room) -> Double {
        
        let area = room.associatedNettingWalls.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedNettingWalls {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * plasterMeshWall
        
    }
    
    func nettingCeilingPrice(room: Room) -> Double {
        
        let area = room.associatedNettingCeilingss.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * plasterMeshCeiling
        
    }
    
    func plasteringWallPrice(room: Room) -> Double {
        
        let area = room.associatedPlasteringWall.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedPlasteringWall {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * plasteringWall
        
    }
    
    func plasteringCeilingPrice(room: Room) -> Double {
        
        let area = room.associatedPlasteringCeiling.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * plasteringCeiling
        
    }
    
    func installationOfCornerStripPrice(room: Room) -> Double {
        
        let basic = room.associatedCornerStrips.reduce(0, { $0 + Int($1.basicMeter)})
        
        var partitionsCircurmference = 0
        
        for wall in room.associatedBricklayingOfPartitions {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            partitionsCircurmference += windowsArea + doorsArea
            
        }
        
        for wall in room.associatedBricklayingOfLoadBearingWalls {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            partitionsCircurmference += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(basic + partitionsCircurmference/100)
        
        return finalAreaInMM * cornerMoldingInstallation
        
    }
    
    func plasterinOfRevealPrice(room: Room) -> Double {
        
        let basic = room.associatedPlasteringOfReveal.reduce(0, { $0 + Int($1.basicMeter)})
        
        var partitionsCircurmference = 0
        
        for wall in room.associatedPlasteringWall {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            partitionsCircurmference += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(basic + partitionsCircurmference/100)
        
        return finalAreaInMM * windowJambPlastering
        
    }
    
    func penetrationCoatPrice(room: Room) -> Double {
        
        let area = room.associatedPenetrationCoat.reduce(0, { $0 + Int($1.height * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * primingPaint
        
    }
    
    func paintingWallPrices(room: Room) -> Double {
        
        let area = room.associatedPaintingWalls.reduce(0, { $0 + Int($1.height * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * wallPaintingTwoLayers
        
        
    }
    
    func paintingCeilingPrices(room: Room) -> Double {
        
        let area = room.associatedPaintingCeilings.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * ceilingPaintingTwoLayers
        
    }
    
    func levellingPrices(room: Room) -> Double {
        
        let area = room.associatedLevellings.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * leveling
        
    }
    
    func layingOfFloatingFloorPrices(room: Room) -> Double {
        
        let area = room.associatedFloatingFloorLayings.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * floatingFloorInstallation
        
    }
    
    func floatingFloorMoldingPrices(room: Room) -> Double {
        
        let area = room.associatedFloatingFloorLayings.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * floatingFloorMolding
        
    }
    
    func tileCeramicPrices(room: Room) -> Double {
        
        let area = room.associatedTileCeramics.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * ceramicTileWall
        
    }
    
    func pavingCeramicPrices(room: Room) -> Double {
        
        let area = room.associatedPavingCeramics.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(area)/10000
        
        return finalAreaInMM * ceramicTileFloor
        
    }
    
    func groutingTilesAndPavingPrices(room: Room) -> Double {
        
        let areaPaving = room.associatedPavingCeramics.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let areaTile = room.associatedTileCeramics.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let areaGrouting = room.associatedGrountingTilesAndPaving.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = Double(areaPaving + areaTile + areaGrouting)/10000
        
        return finalAreaInMM * groutingTile
        
    }
    
    func installationOfSanitaryWarePrices(room: Room) -> Double {
        
        let price = Double(room.associatedInstallationOfSanitaryWiares.reduce(0, { $0 + Int($1.pieces)})) * sanitaryInstallation
        
        return price
        
    }
    
    func installationOfWindowPrices(room: Room) -> Double {
        
        let price = Double(room.associatedWindowInstallations.reduce(0, { $0 + Int($1.basicMeter)})) * windowInstallation
        
        return price
        
    }
    
    func doorFrameInstallationPrices(room: Room) -> Double {
        
        let price = Double(room.associatedInstallationOfLinedDoorFrame.reduce(0, { $0 + Int($1.pieces)})) * doorFrameInstallation
        
        return price
        
    }
    
    func auxilaryWorkPrices(room: Room) -> Double {
        
        let completePrice = demolitionWorkPrice(room: room) +
        electricalWorkPrice(room: room) +
        plumbingWorkPrice(room: room) +
        layingPartitionWallPrice(room: room) +
        layingLoadBearingWallPrice(room: room) +
        plasterboardCeilingPrice(room: room) +
        plasterboardPartitionPrice(room: room) +
        nettingWallPrice(room: room) +
        nettingCeilingPrice(room: room) +
        plasteringWallPrice(room: room) +
        plasteringCeilingPrice(room: room) +
        installationOfCornerStripPrice(room: room) +
        plasterinOfRevealPrice(room: room) +
        penetrationCoatPrice(room: room) +
        paintingWallPrices(room: room) +
        paintingCeilingPrices(room: room) +
        levellingPrices(room: room) +
        layingOfFloatingFloorPrices(room: room) +
        floatingFloorMoldingPrices(room: room) +
        tileCeramicPrices(room: room) +
        pavingCeramicPrices(room: room) +
        groutingTilesAndPavingPrices(room: room) +
        installationOfSanitaryWarePrices(room: room) +
        installationOfWindowPrices(room: room) +
        doorFrameInstallationPrices(room: room)
        
        return completePrice * (auxiliaryFinishingWork/100)
        
    }
    
    func completePriceForWork(room: Room) -> Double {
        
        let auxilaryPrice = auxilaryWorkPrices(room: room)
        
        let completePrice = auxilaryPrice*auxiliaryFinishingWork
        
        return auxilaryPrice + completePrice
        
    }
    
    // MARK: - Materials
    
    func partitionMaterialPrices(room: Room) -> Double {
        
        let area = room.associatedBricklayingOfPartitions.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedBricklayingOfPartitions {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return finalAreaInMM * partitionWall
        
    }
    
    func loadBearingMasonryMaterialPrices(room: Room) -> Double {
        
        let area = room.associatedBricklayingOfLoadBearingWalls.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedBricklayingOfLoadBearingWalls {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        
        return finalAreaInMM * loadbearingWall
        
    }
    
    func plasterBoardCeilingMaterialPrices(room: Room) -> Double {
        
        let area = room.associatedPlasterboardCeilings.reduce(0, { $0 + Int($1.length * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedPlasterboardCeilings {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return (finalAreaInMM/2) * drywallCeilingMaterials
        
    }
    
    func plasterBoardPartitionMaterialPrices(room: Room) -> Double {
        
        let area = room.associatedPlasterboardPartitions.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedPlasterboardPartitions {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(area - areaOfWindowsAndDoors)/10000
        
        return (finalAreaInMM/2) * drywallPartitionMaterials
        
    }
    
    func fiberGlassMeshMaterialPrices(room: Room) -> Double {
        
        let areaOfWalls = room.associatedNettingWalls.reduce(0, { $0 + Int($1.height * $1.width)})
        
        var areaOfWindowsAndDoors = 0
        
        for wall in room.associatedNettingWalls {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height * $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height * $1.width)})
            
            areaOfWindowsAndDoors += windowsArea + doorsArea
            
        }
        
        let areaOfCeiling = room.associatedNettingCeilingss.reduce(0, { $0 + Int($1.length * $1.width)})
        
        let finalAreaInMM = (Double(areaOfCeiling)*1.1 + Double(areaOfWalls - areaOfWindowsAndDoors))/10000
        
        return finalAreaInMM * fiberglassMesh
        
    }
    
    func adhesiveMaterialPrices(room: Room) -> Double {
        
        let finalArea = nettingWallPrice(room: room)/plasterMeshWall + nettingCeilingPrice(room: room)/plasterMeshCeiling + tileCeramicPrices(room: room)/ceramicTileWall + pavingCeramicPrices(room: room)/ceramicTileFloor + partitionMaterialPrices(room: room)/partitionWall
        
        return Double(finalArea)/5 * adhesive
        
    }
    
    func plasterMaterialPrices(room: Room) -> Double {
        
        let finalArea = plasteringWallPrice(room: room)/plasteringWall + plasteringCeilingPrice(room: room)/plasteringCeiling + plasterinOfRevealPrice(room: room)/windowJambPlastering
        
        return finalArea/8 * plaster
        
    }
    
    func cornerMoldingMaterialPrices(room: Room) -> Double {
        
        let basic = room.associatedCornerStrips.reduce(0, { $0 + Int($1.basicMeter)})
        
        var partitionsCircurmference = 0
        
        for wall in room.associatedBricklayingOfPartitions {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            partitionsCircurmference += windowsArea + doorsArea
            
        }
        
        for wall in room.associatedBricklayingOfLoadBearingWalls {
            
            let windowsArea = wall.associatedWindows.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            let doorsArea = wall.associatedDoors.reduce(0, { $0 + Int($1.height*2 + $1.width)})
            
            partitionsCircurmference += windowsArea + doorsArea
            
        }
        
        let finalAreaInMM = Double(basic + partitionsCircurmference/100)
        
        return finalAreaInMM/2 * cornerMolding
        
    }
    
    func penetrationMaterialPrices(room: Room) -> Double {
        
        let finalArea = penetrationCoatPrice(room: room)/primingPaint
        
        return finalArea * primer
        
    }
    
    func wallPaintMaterialPrices(room: Room) -> Double {
        
        let finalArea = paintingWallPrices(room: room)/wallPaintingTwoLayers
        
        return finalArea * wallPaint
        
    }
    
    func ceilingPaintMaterialPrices(room: Room) -> Double {
        
        let finalArea = paintingCeilingPrices(room: room)/ceilingPaintingTwoLayers
        
        return finalArea * ceilingPaint
        
    }
    
    func levellingMaterialPrices(room: Room) -> Double {
        
        let finalArea = levellingPrices(room: room)/leveling
        
        return finalArea * selfLevelingCompound
        
    }
    
    func floatingFloorMaterialPrices(room: Room) -> Double {
        
        let finalArea = layingOfFloatingFloorPrices(room: room)/floatingFloorInstallation
        
        return finalArea * floatingFloor
        
    }
    
    func baseboardMoldingMaterialPrices(room: Room) -> Double {
        
        let finalArea = layingOfFloatingFloorPrices(room: room)/floatingFloorInstallation
        
        return finalArea * baseboardMolding
        
    }
    
    func wallTileMaterialPrices(room: Room) -> Double {
        
        let finalArea = tileCeramicPrices(room: room)/ceramicTileWall
        
        return finalArea * wallTile
        
    }
    
    func floorTileMaterialPrices(room: Room) -> Double {
        
        let finalArea = pavingCeramicPrices(room: room)/ceramicTileFloor
        
        return finalArea * floorTile
        
    }
    
    func auxiliaryConnectingMaterialPrices(room: Room) -> Double {
        let completePrice = partitionMaterialPrices(room: room) +
            loadBearingMasonryMaterialPrices(room: room) +
            plasterBoardCeilingMaterialPrices(room: room) +
            plasterBoardPartitionMaterialPrices(room: room) +
            fiberGlassMeshMaterialPrices(room: room) +
            adhesiveMaterialPrices(room: room) +
            plasterMaterialPrices(room: room) +
            cornerMoldingMaterialPrices(room: room) +
            penetrationMaterialPrices(room: room) +
            wallPaintMaterialPrices(room: room) +
            ceilingPaintMaterialPrices(room: room) +
            levellingMaterialPrices(room: room) +
            floatingFloorMaterialPrices(room: room) +
            baseboardMoldingMaterialPrices(room: room) +
            wallTileMaterialPrices(room: room) +
            floorTileMaterialPrices(room: room)
            
        return completePrice * (auxiliaryConnectingMaterial/100)
    }
    
    func completePriceForMaterials(room: Room) -> Double {
        
        let auxilaryPrice = auxiliaryConnectingMaterialPrices(room: room)
        
        let completePrice = auxilaryPrice*auxiliaryConnectingMaterial
        
        return auxilaryPrice + completePrice
        
    }
    
    // MARK: - Total Price
    func totalPriceForAll(room: Room) -> Double {
        
        return completePriceForWork(room: room) + completePriceForMaterials(room: room)
        
    }
    
}
