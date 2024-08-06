//
//  PricingCalculations.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 31/07/2023.
//

import SwiftUI
import CoreData

final class PricingCalculations: ObservableObject {
    
    private func nettingComplementaryWorkPieces(room: Room) -> Double {
        
        let brickPartition = room.associatedBrickPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.netting
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let brickLoadBearingWall = room.associatedBrickLoadBearingWalls.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.netting
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        return brickPartition + brickLoadBearingWall
        
    }
    
    private func penetrationComplementaryWorkPieces(room: Room) -> Double {
        
        let brickPartition = room.associatedBrickPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.penetration_one
            cleanAreaMultiply += $1.penetration_two
            cleanAreaMultiply += $1.penetration_three
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let brickLoadBearingWall = room.associatedBrickLoadBearingWalls.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.penetration_one
            cleanAreaMultiply += $1.penetration_two
            cleanAreaMultiply += $1.penetration_three
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let plasterboardingPartitions = room.associatedPlasterboardingPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.penetration
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let plasterboardingCeilings = room.associatedPlasterboardingCeilings.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.cleanArea)*cleanAreaMultiply
        })
        
        let nettingWall = room.associatedNettingWalls.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration_one { cleanAreaMultiply += 1 }
            if $1.penetration_two { cleanAreaMultiply += 1 }
            return $0 + ($1.cleanArea)*cleanAreaMultiply
        })
        
        let nettingCeiling = room.associatedNettingCeilingss.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration_one { cleanAreaMultiply += 1 }
            if $1.penetration_two { cleanAreaMultiply += 1 }
            return $0 + ($1.area)*cleanAreaMultiply
        })
        
        let plasteringWall = room.associatedPlasteringWalls.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.cleanArea)*cleanAreaMultiply
        })
        
        let plasteringCeiling = room.associatedPlasteringCeilings.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.area)*cleanAreaMultiply
        })
        
        let plasteringLevelling = room.associatedLevellings.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.area)*cleanAreaMultiply
        })
        
        let plasteringPaintingWall = room.associatedPaintingWalls.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.area)*cleanAreaMultiply
        })
        
        let plasteringPaintingCeiling = room.associatedPaintingCeilings.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.area)*cleanAreaMultiply
        })
        
        let plasterboardingOffsetWall = room.associatedPlasterboardingOffsetWalls.reduce(0.0, {
            var cleanAreaMultiply = 0.0
            if $1.penetration { cleanAreaMultiply += 1 }
            return $0 + ($1.cleanArea)*cleanAreaMultiply
        })
        
        return brickPartition + brickLoadBearingWall + plasterboardingPartitions + plasterboardingCeilings + nettingWall + nettingCeiling + plasteringWall + plasteringCeiling + plasteringLevelling + plasteringPaintingWall + plasteringPaintingCeiling + plasterboardingOffsetWall
        
    }
    
    private func tilingComplementaryWorkPieces(room: Room) -> Double {
        
        let brickPartition = room.associatedBrickPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.tiling
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let brickLoadBearingWall = room.associatedBrickLoadBearingWalls.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.tiling
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let nettingWall = room.associatedNettingWalls.reduce(0.0, { if $1.tiling { return $0 + $1.cleanArea } else { return $0 + 0.0 } })
        
        return brickPartition + brickLoadBearingWall + nettingWall
        
    }
    
    private func plasteringWallComplementaryWorkPieces(room: Room) -> Double {
        
        let brickPartition = room.associatedBrickPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.plastering
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let brickLoadBearingWall = room.associatedBrickLoadBearingWalls.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.plastering
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let nettingWall = room.associatedNettingWalls.reduce(0.0, { if $1.plastering { return $0 + $1.cleanArea } else { return $0 + 0.0 } })
        
        return brickPartition + brickLoadBearingWall + nettingWall
        
    }
    
    private func plasteringCeilingComplementaryWorkPieces(room: Room) -> Double {
        
        let nettingCeiling = room.associatedNettingCeilingss.reduce(0.0, { if $1.plastering { return $0 + $1.area } else { return $0 + 0.0 } })
        
        return nettingCeiling
        
    }
    
    private func paintingWallComplementaryWorkPieces(room: Room) -> Double {
        
        let brickPartition = room.associatedBrickPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.painting
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let brickLoadBearingWall = room.associatedBrickLoadBearingWalls.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.painting
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let plasterboardingPartition = room.associatedPlasterboardingPartitions.reduce(0.0, {
            var cleanAreaMultiply: Int64 = 0
            cleanAreaMultiply += $1.painting
            return $0 + ($1.cleanArea)*Double(cleanAreaMultiply)
        })
        
        let nettingWall = room.associatedNettingWalls.reduce(0.0, {
            if $1.painting { return $0 + $1.cleanArea } else { return $0 + 0.0 }
        })
        
        let plasteringWall = room.associatedPlasteringWalls.reduce(0.0, {
            if $1.painting { return $0 + $1.cleanArea } else { return $0 + 0.0 }
        })
        
        let offsetWall = room.associatedPlasterboardingOffsetWalls.reduce(0.0, {
            if $1.painting { return $0 + $1.cleanArea } else { return $0 + 0.0 }
        })
        
        return brickPartition + brickLoadBearingWall + plasterboardingPartition + nettingWall + plasteringWall + offsetWall
        
    }
    
    private func paintingCeilingComplementaryWorkPieces(room: Room) -> Double {
        
        let plasterboardingCeiling = room.associatedPlasterboardingCeilings.reduce(0.0, { if $1.painting { return $0 + $1.cleanArea } else { return $0 + 0.0 } })
        let nettingCeiling = room.associatedNettingCeilingss.reduce(0.0, { if $1.painting { return $0 + $1.area } else { return $0 + 0.0 } })
        let plasteringCeiling = room.associatedPlasteringCeilings.reduce(0.0, { if $1.painting { return $0 + $1.area } else { return $0 + 0.0 } })
        
        return plasterboardingCeiling + nettingCeiling + plasteringCeiling
        
    }
    
    func roomPriceBillCalculation(room: Room, priceList: PriceList) -> PriceBill {
        
        var priceBill = PriceBill(roomName: RoomTypes.rawValueToString(room.unwrappedName), works: [], materials: [], others: [])
        
        // MARK: Additive Works
        let additiveNettingPieces = nettingComplementaryWorkPieces(room: room)
        let additivePenetrationCoatingPieces = penetrationComplementaryWorkPieces(room: room)
        let additiveTilingPieces = tilingComplementaryWorkPieces(room: room)
        let additivePlasteringWallPieces = plasteringWallComplementaryWorkPieces(room: room)
        let additivePlasteringCeilingPieces = plasteringCeilingComplementaryWorkPieces(room: room)
        let additivePaintingWallPieces = paintingWallComplementaryWorkPieces(room: room)
        let additivePaintingCeilingPieces = paintingCeilingComplementaryWorkPieces(room: room)
        
        // MARK: - WORKS -
        
        // Demolition Work
        let demolitionPieces = room.associatedDemolitions.reduce(0.0, { $0 + $1.count })
        let demolitionPrice =  demolitionPieces * priceList.workDemolitionPrice
        let demolitionRow = PriceBillRow(name: Demolition.title, pieces: demolitionPieces, unit: .hour, price: demolitionPrice)
        priceBill.addWorks(demolitionRow)
        
        // ElectricalWork
        let electricalPieces = room.associatedWirings.reduce(0.0, { $0 + $1.count})
        let electricalPrice = electricalPieces * priceList.workWiringPrice
        let electricalRow = PriceBillRow(name: Wiring.title, pieces: electricalPieces, unit: .piece, price: electricalPrice)
        priceBill.addWorks(electricalRow)
        
        // Plumbing
        let plumbingPieces = room.associatedPlumbings.reduce(0.0, { $0 + $1.count })
        let plumbingPrice = plumbingPieces * priceList.workPlumbingPrice
        let plumbingRow = PriceBillRow(name: Plumbing.title, pieces: plumbingPieces, unit: .piece, price: plumbingPrice)
        priceBill.addWorks(plumbingRow)
        
        // LayingPartitionWall
        let layingPartitionPieces = room.associatedBrickPartitions.reduce(0.0, { $0 + $1.cleanArea })
        let layingPartitionPrice = layingPartitionPieces * priceList.workBrickPartitionsPrice
        let layingPartitionRow = PriceBillRow(name: BrickPartition.title, pieces: layingPartitionPieces, unit: .squareMeter, price: layingPartitionPrice)
        priceBill.addWorks(layingPartitionRow)
        
        // LayingLoadBearingWall
        let layingLoadBearingPieces = room.associatedBrickLoadBearingWalls.reduce(0.0, { $0 + $1.cleanArea })
        let layingLoadBearingPrice = layingLoadBearingPieces * priceList.workBrickLoadBearingWallPrice
        let layingLoadBearingRow = PriceBillRow(name: BrickLoadBearingWall.title, pieces: layingLoadBearingPieces, unit: .squareMeter, price: layingLoadBearingPrice)
        priceBill.addWorks(layingLoadBearingRow)
        
        // SimplePlasterBoardPartition
        let simplePlasterBoardPartitionPieces = room.associatedSimplePlasterboardingPartitions.reduce(0.0, { $0 + $1.cleanArea })
        let simplePlasterBoardPartitionPrice = simplePlasterBoardPartitionPieces * priceList.workSimplePlasterboardingPartitionPrice
        let simplePlasterBoardPartitionRow = PriceBillRow(name: PlasterboardingPartition.simpleBillSubTitle, pieces: simplePlasterBoardPartitionPieces, unit: .squareMeter, price: simplePlasterBoardPartitionPrice)
        priceBill.addWorks(simplePlasterBoardPartitionRow)
        
        // DoublePlasterBoardPartition
        let doublePlasterBoardPartitionPieces = room.associatedDoublePlasterboardingPartitions.reduce(0.0, { $0 + $1.cleanArea })
        let doublePlasterBoardPartitionPrice = doublePlasterBoardPartitionPieces * priceList.workDoublePlasterboardingPartitionPrice
        let doublePlasterBoardPartitionRow = PriceBillRow(name: PlasterboardingPartition.doubleBillSubTitle, pieces: doublePlasterBoardPartitionPieces, unit: .squareMeter, price: doublePlasterBoardPartitionPrice)
        priceBill.addWorks(doublePlasterBoardPartitionRow)
        
        // TriplePlasterBoardPartition
        let triplePlasterBoardPartitionPieces = room.associatedTriplePlasterboardingPartitions.reduce(0.0, { $0 + $1.cleanArea })
        let triplePlasterBoardPartitionPrice = triplePlasterBoardPartitionPieces * priceList.workTriplePlasterboardingPartitionPrice
        let triplePlasterBoardPartitionRow = PriceBillRow(name: PlasterboardingPartition.tripleBillSubTitle, pieces: triplePlasterBoardPartitionPieces, unit: .squareMeter, price: triplePlasterBoardPartitionPrice)
        priceBill.addWorks(triplePlasterBoardPartitionRow)
        
        // SimplePlasterBoardOffsetWall
        let simplePlasterBoardOffsetWallPieces = room.associatedSimplePlasterboardingOffsetWalls.reduce(0.0, { $0 + $1.cleanArea })
        let simplePlasterBoardOffsetWallPrice = simplePlasterBoardOffsetWallPieces * priceList.workSimplePlasterboardingOffsetWallPrice
        let simplePlasterBoardOffsetWallRow = PriceBillRow(name: PlasterboardingOffsetWall.simpleBillSubTitle, pieces: simplePlasterBoardOffsetWallPieces, unit: .squareMeter, price: simplePlasterBoardOffsetWallPrice)
        priceBill.addWorks(simplePlasterBoardOffsetWallRow)
        
        // DoublePlasterBoardOffsetWall
        let doublePlasterBoardOffsetWallPieces = room.associatedDoublePlasterboardingOffsetWalls.reduce(0.0, { $0 + $1.cleanArea })
        let doublePlasterBoardOffsetWallPrice = doublePlasterBoardOffsetWallPieces * priceList.workDoublePlasterboardingOffsetWallPrice
        let doublePlasterBoardOffsetWallRow = PriceBillRow(name: PlasterboardingOffsetWall.doubleBillSubTitle, pieces: doublePlasterBoardOffsetWallPieces, unit: .squareMeter, price: doublePlasterBoardOffsetWallPrice)
        priceBill.addWorks(doublePlasterBoardOffsetWallRow)
        
        // PlasterBoardingCeiling
        let plasterBoardCielingPieces = room.associatedPlasterboardingCeilings.reduce(0.0, { $0 + $1.cleanArea })
        let plasterBoardCielingPrice = plasterBoardCielingPieces * priceList.workPlasterboardingCeilingPrice
        let plasterBoardCielingRow = PriceBillRow(name: PlasterboardingCeiling.billSubTitle, pieces: plasterBoardCielingPieces, unit: .squareMeter, price: plasterBoardCielingPrice)
        priceBill.addWorks(plasterBoardCielingRow)
        
        // PlasterNettingWall
        let workNettingWallPricePieces = room.associatedNettingWalls.reduce(0.0, { $0 + $1.cleanArea }) + additiveNettingPieces
        let workNettingWallPricePrice = workNettingWallPricePieces * priceList.workNettingWallPrice
        let workNettingWallPriceRow = PriceBillRow(name: NettingWall.billSubTitle, pieces: workNettingWallPricePieces, unit: .squareMeter, price: workNettingWallPricePrice)
        priceBill.addWorks(workNettingWallPriceRow)
        
        // PlasterNettingCeiling
        let workNettingCeilingPricePieces = room.associatedNettingCeilingss.reduce(0.0, { $0 + $1.area })
        let workNettingCeilingPricePrice = workNettingCeilingPricePieces * priceList.workNettingCeilingPrice
        let workNettingCeilingPriceRow = PriceBillRow(name: NettingCeiling.billSubTitle, pieces: workNettingCeilingPricePieces, unit: .squareMeter, price: workNettingCeilingPricePrice)
        priceBill.addWorks(workNettingCeilingPriceRow)
        
        // PlasteringWall
        let plasteringWallPieces = room.associatedPlasteringWalls.reduce(0.0, { $0 + $1.cleanArea }) + additivePlasteringWallPieces
        let plasteringWallPrice = plasteringWallPieces * priceList.workPlasteringWallPrice
        let plasteringWallRow = PriceBillRow(name: PlasteringWall.billSubTitle, pieces: plasteringWallPieces, unit: .squareMeter, price: plasteringWallPrice)
        priceBill.addWorks(plasteringWallRow)
        
        // PlasteringCeiling
        let plasteringCeilingPieces = room.associatedPlasteringCeilings.reduce(0.0, { $0 + $1.area }) + additivePlasteringCeilingPieces
        let plasteringCeilingPrice = plasteringCeilingPieces * priceList.workPlasteringCeilingPrice
        let plasteringCeilingRow = PriceBillRow(name: PlasteringCeiling.billSubTitle, pieces: plasteringCeilingPieces, unit: .squareMeter, price: plasteringCeilingPrice)
        priceBill.addWorks(plasteringCeilingRow)
        
        // FacadePlasteringCeiling
        let facadePlasteringPieces = room.associatedFacadePlasterings.reduce(0.0, { $0 + $1.cleanArea })
        let facadePlasteringPrice = facadePlasteringPieces * priceList.workFacadePlastering
        let facadePlasteringRow = PriceBillRow(name: FacadePlastering.title, pieces: facadePlasteringPieces, unit: .squareMeter, price: facadePlasteringPrice)
        priceBill.addWorks(facadePlasteringRow)
        
        // CornerStrips
        let cornerStripsPieces = room.associatedInstallationOfCornerBeads.reduce(0.0, { $0 + $1.count })
        let cornerStripsPrice = cornerStripsPieces * priceList.workInstallationOfCornerBeadPrice
        let cornerStripsRow = PriceBillRow(name: InstallationOfCornerBead.title, pieces: cornerStripsPieces, unit: .basicMeter, price: cornerStripsPrice)
        priceBill.addWorks(cornerStripsRow)
        
        // PlasteringOfWindowSash
        let plasteringOfRevealPieces = room.associatedPlasteringOfWindowSasheses.reduce(0.0, { $0 + $1.count })
        let plasteringOfRevealPrice = plasteringOfRevealPieces * priceList.workPlasteringOfWindowSashPrice
        let plasteringOfRevealRow = PriceBillRow(name: PlasteringOfWindowSash.title, pieces: plasteringOfRevealPieces, unit: .basicMeter, price: plasteringOfRevealPrice)
        priceBill.addWorks(plasteringOfRevealRow)
        
        // PenetrationCoating
        let penetrationCoatPieces = room.associatedPenetrationCoatings.reduce(0.0, { $0 + $1.area }) + additivePenetrationCoatingPieces
        let penetrationCoatPrice = penetrationCoatPieces * priceList.workPenetrationCoatingPrice
        let penetrationCoatRow = PriceBillRow(name: PenetrationCoating.title, pieces: penetrationCoatPieces, unit: .squareMeter, price: penetrationCoatPrice)
        priceBill.addWorks(penetrationCoatRow)
        
        // PaintingWalls
        let paintingWallsPieces = room.associatedPaintingWalls.reduce(0.0, { $0 + $1.area }) + additivePaintingWallPieces
        let paintingWallsPrice = paintingWallsPieces * priceList.workPaintingWallPrice
        let paintingWallsRow = PriceBillRow(name: PaintingWall.billSubTitle, pieces: paintingWallsPieces, unit: .squareMeter, price: paintingWallsPrice)
        priceBill.addWorks(paintingWallsRow)
        
        // PaintingCeilings
        let paintingCeilingsPieces = room.associatedPaintingCeilings.reduce(0.0, { $0 + $1.area }) + additivePaintingCeilingPieces
        let paintingCeilingsPrice = paintingCeilingsPieces * priceList.workPaintingCeilingPrice
        let paintingCeilingsRow = PriceBillRow(name: PaintingCeiling.billSubTitle, pieces: paintingCeilingsPieces, unit: .squareMeter, price: paintingCeilingsPrice)
        priceBill.addWorks(paintingCeilingsRow)
        
        // Levelling
        let levellingPieces = room.associatedLevellings.reduce(0.0, { $0 + $1.area })
        let levellingPrice = levellingPieces * priceList.workLevellingPrice
        let levellingRow = PriceBillRow(name: Levelling.title, pieces: levellingPieces, unit: .squareMeter, price: levellingPrice)
        priceBill.addWorks(levellingRow)
        
        // LayingFloatingFloors
        let floatingFloorLayingPieces = room.associatedLayingFloatingFloors.reduce(0.0, { $0 + $1.area })
        let floatingFloorLayingPrice = floatingFloorLayingPieces * priceList.workLayingFloatingFloorsPrice
        let floatingFloorLayingRow = PriceBillRow(name: LayingFloatingFloors.billSubTitle, pieces: floatingFloorLayingPieces, unit: .squareMeter, price: floatingFloorLayingPrice)
        priceBill.addWorks(floatingFloorLayingRow)
        
        // Skirting of Floating Floor
        let skirtingFloatingFloorPieces = ceil(room.associatedSkirtingsOfFloatingFloor.reduce(0.0, { $0 + $1.count }) + room.associatedLayingFloatingFloors.reduce(0.0, { $0 + $1.circurmference }))
        let skirtingFloatingFloorPrice = skirtingFloatingFloorPieces * priceList.workSkirtingOfFloatingFloorPrice
        let skirtingFloatingFloorRow = PriceBillRow(name: SkirtingOfFloatingFloor.title, pieces: skirtingFloatingFloorPieces, unit: .basicMeter, price: skirtingFloatingFloorPrice)
        priceBill.addWorks(skirtingFloatingFloorRow)
        
        // TilingCeramic
        let tilingCeramicPieces = room.associatedTileCeramics.reduce(0.0, {
            if !$1.largeFormat {
                return $0 + $1.cleanArea
            } else {
                return $0
            }
        }) + additiveTilingPieces
        let tilingCeramicPrice = tilingCeramicPieces * priceList.workTilingCeramicPrice
        let tilingCeramicRow = PriceBillRow(name: TileCeramic.billSubTitle, pieces: tilingCeramicPieces, unit: .squareMeter, price: tilingCeramicPrice)
        priceBill.addWorks(tilingCeramicRow)
        
        let tilingLFCeramicPieces = room.associatedTileCeramics.reduce(0.0, {
            if $1.largeFormat {
                return $0 + $1.cleanArea
            } else { return $0 }
        })
        let tilingLFCeramicPrice = tilingLFCeramicPieces * priceList.workLargeFormatPavingAndTilingPrice
        let tilingLFCeramicRow = PriceBillRow(name: LargeFormatPavingAndTiling.tilingBillTitle, pieces: tilingLFCeramicPieces, unit: .squareMeter, price: tilingLFCeramicPrice)
        priceBill.addWorks(tilingLFCeramicRow)
        
        let jollyEdgingPieces = room.associatedTileCeramics.reduce(0.0, {
            $0 + $1.jollyEdging
        })
        let jollyEdgingPrice = jollyEdgingPieces * priceList.workJollyEdgingPrice
        let jollyEdgingRow = PriceBillRow(name: JollyEdging.title, pieces: jollyEdgingPieces, unit: JollyEdging.unit, price: jollyEdgingPrice)
        priceBill.addWorks(jollyEdgingRow)
        
        // PavingCeramic
        let pavingCeramicPieces = room.associatedPavingCeramics.reduce(0.0, {
            if !$1.largeFormat {
                return $0 + $1.area
            } else {
                return $0
            }
        })
        let pavingCeramicPrice = pavingCeramicPieces * priceList.workPavingCeramicPrice
        let pavingCeramicRow = PriceBillRow(name: PavingCeramic.billSubTitle, pieces: pavingCeramicPieces, unit: .squareMeter, price: pavingCeramicPrice)
        priceBill.addWorks(pavingCeramicRow)
        
        let pavingLFCeramicPieces = room.associatedPavingCeramics.reduce(0.0, {
            if $1.largeFormat {
                return $0 + $1.area
            } else {
                return $0
            }
        })
        let pavingLFCeramicPrice = pavingLFCeramicPieces * priceList.workLargeFormatPavingAndTilingPrice
        let pavingLFCeramicRow = PriceBillRow(name: LargeFormatPavingAndTiling.pavingBillTitle, pieces: pavingLFCeramicPieces, unit: .squareMeter, price: pavingLFCeramicPrice)
        priceBill.addWorks(pavingLFCeramicRow)
        
        let plinthCuttingPieces = room.associatedPavingCeramics.reduce(0.0, {
            $0 + $1.plinthCutting
        })
        let plinthCuttingPrice = plinthCuttingPieces * priceList.workPlinthCutting
        let plinthCuttingRow = PriceBillRow(name: PlinthCutting.billTitle, pieces: plinthCuttingPieces, unit: PlinthCutting.unit, price: plinthCuttingPrice)
        priceBill.addWorks(plinthCuttingRow)
        
        let plinthBondingPieces = room.associatedPavingCeramics.reduce(0.0, {
            $0 + $1.plinthBonding
        })
        let plinthBondingPrice = plinthBondingPieces * priceList.workPlinthBonding
        let plinthBondingRow = PriceBillRow(name: PlinthBonding.billTitle, pieces: plinthBondingPieces, unit: PlinthBonding.unit, price: plinthBondingPrice)
        priceBill.addWorks(plinthBondingRow)
        
        
        // Grouting
        let groutingTilesAndPavingPieces = room.associatedGroutings.reduce(0.0, { $0 + $1.area }) + tilingCeramicPieces + pavingCeramicPieces
        let groutingTilesAndPavingPrice = groutingTilesAndPavingPieces * priceList.workGroutingPrice
        let groutingTilesAndPavingRow = PriceBillRow(name: Grouting.billSubTitle, pieces: groutingTilesAndPavingPieces, unit: .squareMeter, price: groutingTilesAndPavingPrice)
        priceBill.addWorks(groutingTilesAndPavingRow)
        
        // Siliconing
        let siliconizationPieces = room.associatedSiliconings.reduce(0.0, { $0 + $1.count })
        let siliconizationPrice = siliconizationPieces * priceList.workSiliconingPrice
        let siliconizationRow = PriceBillRow(name: Siliconing.title, pieces: siliconizationPieces, unit: .basicMeter, price: siliconizationPrice)
        priceBill.addWorks(siliconizationRow)
        
        
        // InstallationOfSanitary
        var cornerValveCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.cornerValve), pieces: 0, unit: .piece, price: 0.0)
        var standFaucetCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.standFaucet), pieces: 0, unit: .piece, price: 0.0)
        var wallFaucetCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.wallFaucet), pieces: 0, unit: .piece, price: 0.0)
        var concealedFaucetCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.concealedFaucet), pieces: 0, unit: .piece, price: 0.0)
        var combiToiletCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.combiToilet), pieces: 0, unit: .piece, price: 0.0)
        var concealedToiletCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.concealedToilet), pieces: 0, unit: .piece, price: 0.0)
        var sinkCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.sink), pieces: 0, unit: .piece, price: 0.0)
        var sinkWithCabinetCountAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.sinkWithCabinet), pieces: 0, unit: .piece, price: 0.0)
        var showerAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.shower), pieces: 0, unit: .piece, price: 0.0)
        var bathtubAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.bathtub), pieces: 0, unit: .piece, price: 0.0)
        var installationOfGutterAndPrice: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.installationOfGutter), pieces: 0, unit: .piece, price: 0.0)
        var urinalAndPrice: PriceBillRow = .init(name: SanitaryTypes.readableSymbol(.urinal), pieces: 0, unit: .piece, price: 0.0)
        var bathScreenAndPrice: PriceBillRow = .init(name: SanitaryTypes.readableSymbol(.bathScreen), pieces: 0, unit: .piece, price: 0.0)
        var mirrorAndPrice: PriceBillRow = .init(name: SanitaryTypes.readableSymbol(.mirror), pieces: 0, unit: .piece, price: 0.0)
        
        var cornerValveCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.cornerValve), pieces: 0, unit: .piece, price: 0.0)
        var standFaucetCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.standFaucet), pieces: 0, unit: .piece, price: 0.0)
        var wallFaucetCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.wallFaucet), pieces: 0, unit: .piece, price: 0.0)
        var concealedFaucetCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.concealedFaucet), pieces: 0, unit: .piece, price: 0.0)
        var combiToiletCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.combiToilet), pieces: 0, unit: .piece, price: 0.0)
        var concealedToiletCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.concealedToilet), pieces: 0, unit: .piece, price: 0.0)
        var sinkCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.sink), pieces: 0, unit: .piece, price: 0.0)
        var sinkWithCabinetCountAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.sinkWithCabinet), pieces: 0, unit: .piece, price: 0.0)
        var showerAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.shower), pieces: 0, unit: .piece, price: 0.0)
        var bathtubAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.bathtub), pieces: 0, unit: .piece, price: 0.0)
        var installationOfGutterAndMaterial: PriceBillRow = PriceBillRow(name: SanitaryTypes.readableSymbol(.installationOfGutter), pieces: 0, unit: .piece, price: 0.0)
        var urinalMaterial: PriceBillRow = .init(name: SanitaryTypes.readableSymbol(.urinal), pieces: 0, unit: .piece, price: 0.0)
        var bathScreenMaterial: PriceBillRow = .init(name: SanitaryTypes.readableSymbol(.bathScreen), pieces: 0, unit: .piece, price: 0.0)
        var mirrorMaterial: PriceBillRow = .init(name: SanitaryTypes.readableSymbol(.mirror), pieces: 0, unit: .piece, price: 0.0)
        
        for ware in room.associatedInstallationOfSanitarysByType {
            switch SanitaryTypes(rawValue: ware.key) {
            case .some(.cornerValve):
                cornerValveCountAndPrice.pieces = ware.value.0
                cornerValveCountAndPrice.price = ware.value.0 * priceList.workSanitaryCornerValvePrice
                cornerValveCountAndMaterial.pieces = ware.value.0
                cornerValveCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.standFaucet):
                standFaucetCountAndPrice.pieces = ware.value.0
                standFaucetCountAndPrice.price = ware.value.0 * priceList.workSanitaryStandingMixerTapPrice
                standFaucetCountAndMaterial.pieces = ware.value.0
                standFaucetCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.wallFaucet):
                wallFaucetCountAndPrice.pieces = ware.value.0
                wallFaucetCountAndPrice.price = ware.value.0 * priceList.workSanitaryWallMountedTapPrice
                wallFaucetCountAndMaterial.pieces = ware.value.0
                wallFaucetCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.concealedFaucet):
                concealedFaucetCountAndPrice.pieces = ware.value.0
                concealedFaucetCountAndPrice.price = ware.value.0 * priceList.workSanitaryFlushMountedTapPrice
                concealedFaucetCountAndMaterial.pieces = ware.value.0
                concealedFaucetCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.combiToilet):
                combiToiletCountAndPrice.pieces = ware.value.0
                combiToiletCountAndPrice.price = ware.value.0 * priceList.workSanitaryToiletCombiPrice
                combiToiletCountAndMaterial.pieces = ware.value.0
                combiToiletCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.concealedToilet):
                concealedToiletCountAndPrice.pieces = ware.value.0
                concealedToiletCountAndPrice.price = ware.value.0 * priceList.workSanitaryToiletWithConcealedCisternPrice
                concealedToiletCountAndMaterial.pieces = ware.value.0
                concealedToiletCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.sink):
                sinkCountAndPrice.pieces = ware.value.0
                sinkCountAndPrice.price = ware.value.0 * priceList.workSanitarySinkPrice
                sinkCountAndMaterial.pieces = ware.value.0
                sinkCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.sinkWithCabinet):
                sinkWithCabinetCountAndPrice.pieces = ware.value.0
                sinkWithCabinetCountAndPrice.price = ware.value.0 * priceList.workSanitarySinkWithCabinetPrice
                sinkWithCabinetCountAndMaterial.pieces = ware.value.0
                sinkWithCabinetCountAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.shower):
                showerAndPrice.pieces = ware.value.0
                showerAndPrice.price = ware.value.0 * priceList.workSanitaryShowerCubiclePrice
                showerAndMaterial.pieces = ware.value.0
                showerAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.bathtub):
                bathtubAndPrice.pieces = ware.value.0
                bathtubAndPrice.price = ware.value.0 * priceList.workSanitaryBathtubPrice
                bathtubAndMaterial.pieces = ware.value.0
                bathtubAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.installationOfGutter):
                installationOfGutterAndPrice.pieces = ware.value.0
                installationOfGutterAndPrice.price = ware.value.0 * priceList.workSanitaryGutterPrice
                installationOfGutterAndMaterial.pieces = ware.value.0
                installationOfGutterAndMaterial.price = ware.value.1 * ware.value.0
            case .some(.urinal):
                urinalAndPrice.pieces = ware.value.0
                urinalAndPrice.price = ware.value.0 * priceList.workSanitaryUrinal
                urinalMaterial.pieces = ware.value.0
                urinalMaterial.price = ware.value.1 * ware.value.0
            case .some(.bathScreen):
                bathScreenAndPrice.pieces = ware.value.0
                bathScreenAndPrice.price = ware.value.0 * priceList.workSanitaryBathScreen
                bathScreenMaterial.pieces = ware.value.0
                bathScreenMaterial.price = ware.value.1 * ware.value.0
            case .some(.mirror):
                mirrorAndPrice.pieces = ware.value.0
                mirrorAndPrice.price = ware.value.0 * priceList.workSanitaryMirror
                mirrorMaterial.pieces = ware.value.0
                mirrorMaterial.price = ware.value.1 * ware.value.0
            case .none:
                print("Non existant sanitary type.")
            }
        }
        priceBill.addWorks(cornerValveCountAndPrice)
        priceBill.addWorks(standFaucetCountAndPrice)
        priceBill.addWorks(wallFaucetCountAndPrice)
        priceBill.addWorks(concealedFaucetCountAndPrice)
        priceBill.addWorks(combiToiletCountAndPrice)
        priceBill.addWorks(concealedToiletCountAndPrice)
        priceBill.addWorks(sinkCountAndPrice)
        priceBill.addWorks(sinkWithCabinetCountAndPrice)
        priceBill.addWorks(showerAndPrice)
        priceBill.addWorks(bathtubAndPrice)
        priceBill.addWorks(installationOfGutterAndPrice)
        priceBill.addWorks(urinalAndPrice)
        priceBill.addWorks(bathScreenAndPrice)
        priceBill.addWorks(mirrorAndPrice)
        
        // WindowInstallation
        let windowInstallationPieces = room.associatedWindowInstallations.reduce(0.0, { $0 + $1.count })
        let windowInstallationPrice = windowInstallationPieces * priceList.workWindowInstallationPrice
        let windowInstallationRow = PriceBillRow(name: WindowInstallation.title, pieces: windowInstallationPieces, unit: .basicMeter, price: windowInstallationPrice)
        priceBill.addWorks(windowInstallationRow)
        
        // InstallationOfDoorJamb
        let installationOfLinedDoorFramePieces = room.associatedInstallationOfDoorJambss.reduce(0.0, { $0 + $1.count })
        let installationOfLinedDoorFramePrice = installationOfLinedDoorFramePieces * priceList.workDoorJambInstallationPrice
        let installationOfLinedDoorFrameRow = PriceBillRow(name: InstallationOfDoorJamb.title, pieces: installationOfLinedDoorFramePieces, unit: .piece, price: installationOfLinedDoorFramePrice)
        priceBill.addWorks(installationOfLinedDoorFrameRow)
        
        // CustomWorks
        for customWork in room.associatedCustomWorks {
            
            let customWorkTitlePreCursor = customWork.title == nil ? String(localized: "Custom Work") : customWork.title ?? ""
            let customWorkTitle = customWorkTitlePreCursor.isEmpty ? String(localized: "Custom Work") : customWorkTitlePreCursor
            
            let customWorkRow = PriceBillRow(name: customWorkTitle, pieces: customWork.numberOfUnits, unit: UnitsOfMeasurement.parse(customWork.unit), price: customWork.numberOfUnits * customWork.pricePerUnit)
            
            priceBill.addWorks(customWorkRow)
            
        }
        
        // AuxilaryWork
        let auxilaryWorkPrice = priceBill.worksPrice * (priceList.workAuxiliaryAndFinishingPrice/100)
        let auxilaryWorkRow = PriceBillRow(name: AuxiliaryAndFinishingWork.title, pieces: priceList.workAuxiliaryAndFinishingPrice, unit: .percentage, price: auxilaryWorkPrice)
        priceBill.addWorks(auxilaryWorkRow)
        
        // MARK: - MATERIALS -
        
        // PartitionMaterial
        let partitionMaterialPrice = ceil(layingPartitionPieces) * priceList.materialPartitionMasonryPrice
        let partitionMaterialRow = PriceBillRow(name: PartitionMasonry.title, pieces: ceil(layingPartitionPieces), unit: .squareMeter, price: partitionMaterialPrice)
        priceBill.addMaterials(partitionMaterialRow)
        
        // LoadbearingWallMaterial
        let loadbearingWallMaterialPrice = ceil(layingLoadBearingPieces) *
        priceList.materialLoadBearingMasonryPrice
        let loadbearingWallMaterialRow = PriceBillRow(name: LoadBearingMasonry.title, pieces: ceil(layingLoadBearingPieces), unit: .squareMeter, price: loadbearingWallMaterialPrice)
        priceBill.addMaterials(loadbearingWallMaterialRow)
        
        // SimplePlasterBoardPartitionMaterial
        let simpleAreaOfPlasterBoard = simplePlasterBoardPartitionPieces*2
        let simplePlasterBoardPartitionMaterialPieces = ceil(simpleAreaOfPlasterBoard/priceList.materialSimplePlasterboardingPartitionCapacity)
        let simplePlasterBoardPartitionMaterialPrice = simplePlasterBoardPartitionMaterialPieces * priceList.materialSimplePlasterboardingPartitionPrice
        let simplePlasterBoardPartitionMaterialRow = PriceBillRow(name: SimplePlasterboardPartition.billSubTitle, pieces: simplePlasterBoardPartitionMaterialPieces, unit: .piece, price: simplePlasterBoardPartitionMaterialPrice)
        priceBill.addMaterials(simplePlasterBoardPartitionMaterialRow)
        
        // DoublePlasterBoardPartitionMaterial
        let doubleAreaOfPlasterBoard = doublePlasterBoardPartitionPieces*4
        let doublePlasterBoardPartitionMaterialPieces = ceil(doubleAreaOfPlasterBoard/priceList.materialDoublePlasterboardingPartitionCapacity)
        let doublePlasterBoardPartitionMaterialPrice = doublePlasterBoardPartitionMaterialPieces * priceList.materialDoublePlasterboardingPartitionPrice
        let doublePlasterBoardPartitionMaterialRow = PriceBillRow(name: DoublePlasterboardPartition.billSubTitle, pieces: doublePlasterBoardPartitionMaterialPieces, unit: .piece, price: doublePlasterBoardPartitionMaterialPrice)
        priceBill.addMaterials(doublePlasterBoardPartitionMaterialRow)
        
        // TriplePlasterBoardPartitionMaterial
        let tripleAreaOfPlasterBoard = triplePlasterBoardPartitionPieces*6
        let triplePlasterBoardPartitionMaterialPieces = ceil(tripleAreaOfPlasterBoard/priceList.materialTriplePlasterboardingPartitionCapacity)
        let triplePlasterBoardPartitionMaterialPrice = triplePlasterBoardPartitionMaterialPieces * priceList.materialTriplePlasterboardingPartitionPrice
        let triplePlasterBoardPartitionMaterialRow = PriceBillRow(name: TriplePlasterboardPartition.billSubTitle, pieces: triplePlasterBoardPartitionMaterialPieces, unit: .piece, price: triplePlasterBoardPartitionMaterialPrice)
        priceBill.addMaterials(triplePlasterBoardPartitionMaterialRow)
        
        // SimplePlasterBoardOffsetWallMaterial
        let simpleAreaOfPlasterOffsetWall = simplePlasterBoardOffsetWallPieces
        let simplePlasterBoardOffsetWallMaterialPieces = ceil(simpleAreaOfPlasterOffsetWall/priceList.materialSimplePlasterboardingOffsetWallCapacity)
        let simplePlasterBoardOffsetWallMaterialPrice = simplePlasterBoardOffsetWallMaterialPieces * priceList.materialSimplePlasterboardingOffsetWallPrice
        let simplePlasterBoardOffsetWallMaterialRow = PriceBillRow(name: SimplePlasterboardOffsetWall.billSubTitle, pieces: simplePlasterBoardOffsetWallMaterialPieces, unit: .piece, price: simplePlasterBoardOffsetWallMaterialPrice)
        priceBill.addMaterials(simplePlasterBoardOffsetWallMaterialRow)
        
        // DoublePlasterBoardOffsetWallMaterial
        let doubleAreaOfPlasterOffsetWall = doublePlasterBoardOffsetWallPieces*2
        let doublePlasterBoardOffsetWallMaterialPieces = ceil(doubleAreaOfPlasterOffsetWall/priceList.materialDoublePlasterboardingOffsetWallCapacity)
        let doublePlasterBoardOffsetWallMaterialPrice = doublePlasterBoardOffsetWallMaterialPieces * priceList.materialDoublePlasterboardingOffsetWallPrice
        let doublePlasterBoardOffsetWallMaterialRow = PriceBillRow(name: DoublePlasterboardOffsetWall.billSubTitle, pieces: doublePlasterBoardOffsetWallMaterialPieces, unit: .piece, price: doublePlasterBoardOffsetWallMaterialPrice)
        priceBill.addMaterials(doublePlasterBoardOffsetWallMaterialRow)
        
        // PlasterBoardCeilingMaterial
        let plasterBoardCeilingMaterialPieces = ceil(plasterBoardCielingPieces/priceList.materialPlasterboardingCeilingCapacity)
        let plasterBoardCeilingMaterialPrice = plasterBoardCeilingMaterialPieces * priceList.materialPlasterboardingCeilingPrice
        let plasterBoardCeilingMaterialRow = PriceBillRow(name: PlasterboardCeiling.billSubTitle, pieces: plasterBoardCeilingMaterialPieces, unit: .piece, price: plasterBoardCeilingMaterialPrice)
        priceBill.addMaterials(plasterBoardCeilingMaterialRow)
        
        // FiberGlassMeshMaterial
        let fiberGlassMeshMaterialPieces = ceil(workNettingWallPricePieces*1.1 + workNettingCeilingPricePieces*1.1)
        let fiberGlassMeshMaterialPrice = fiberGlassMeshMaterialPieces * priceList.materialMeshPrice
        let fiberGlassMeshMaterialRow = PriceBillRow(name: Mesh.title, pieces: fiberGlassMeshMaterialPieces, unit: .squareMeter, price: fiberGlassMeshMaterialPrice)
        priceBill.addMaterials(fiberGlassMeshMaterialRow)
        
        // AdhesiveForNettingMaterial
        let adhesiveForNettingMaterialPieces = ceil((workNettingWallPricePieces + plasteringCeilingPieces)/priceList.materialAdhesiveNettingCapacity)
        let adhesiveForNettingMaterialPrice = adhesiveForNettingMaterialPieces * priceList.materialAdhesiveNettingPrice
        let adhesiveForNettingMaterialRow = PriceBillRow(name: AdhesiveNetting.billSubTitle, pieces: adhesiveForNettingMaterialPieces, unit: .package, price: adhesiveForNettingMaterialPrice)
        priceBill.addMaterials(adhesiveForNettingMaterialRow)
        
        // AdhesiveForTilingMaterial
        let adhesiveForTilingMaterialPieces = ceil((tilingCeramicPieces + pavingCeramicPieces)/priceList.materialAdhesiveTilingAndPavingCapacity)
        let adhesiveForTilingMaterialPrice = adhesiveForTilingMaterialPieces * priceList.materialAdhesiveTilingAndPavingPrice
        let adhesiveForTilingMaterialRow = PriceBillRow(name: AdhesiveTilingAndPaving.billSubTitle, pieces: adhesiveForTilingMaterialPieces, unit: .package, price: adhesiveForTilingMaterialPrice)
        priceBill.addMaterials(adhesiveForTilingMaterialRow)
        
        // PlasterMaterial
        let plasterMaterialPieces = ceil((plasteringWallPieces + plasteringCeilingPieces + plasteringOfRevealPieces)/priceList.materialPlasterCapacity)
        let plasterMaterialPrice = plasterMaterialPieces * priceList.materialPlasterPrice
        let plasterMaterialRow = PriceBillRow(name: Plaster.title, pieces: plasterMaterialPieces, unit: .package, price: plasterMaterialPrice)
        priceBill.addMaterials(plasterMaterialRow)
        
        // FacadePlasterMaterial
        let facadePlasterMaterialPieces = ceil(facadePlasteringPieces/priceList.materialPlasterCapacity)
        let facadePlasterMaterialPrice = facadePlasterMaterialPieces * priceList.materialFacadePlasterPrice
        let facadePlasterMaterialRow = PriceBillRow(name: FacadePlaster.title, pieces: facadePlasterMaterialPieces, unit: .package, price: facadePlasterMaterialPrice)
        priceBill.addMaterials(facadePlasterMaterialRow)
        
        // CornerMoldingMaterial
        let circumferenceOfCornerStrips = room.associatedInstallationOfCornerBeads.reduce(0.0, { $0 + $1.count })
        let cornerMoldingMaterialPieces = ceil(circumferenceOfCornerStrips/priceList.materialCornerBeadCapacity)
        let cornerMoldingMaterialPrice = cornerMoldingMaterialPieces * priceList.materialCornerBeadPrice
        let cornerMoldingMaterialRow = PriceBillRow(name: CornerBead.title, pieces: cornerMoldingMaterialPieces, unit: .piece, price: cornerMoldingMaterialPrice)
        priceBill.addMaterials(cornerMoldingMaterialRow)
        
        // PenetrationMaterial
        let penetrationMaterialPrice = ceil(penetrationCoatPieces) * priceList.materialPrimerPrice
        let penetrationMaterialRow = PriceBillRow(name: Primer.title, pieces: ceil(penetrationCoatPieces), unit: .squareMeter, price: penetrationMaterialPrice)
        priceBill.addMaterials(penetrationMaterialRow)
        
        // WallPaintMaterial
        let wallPaintMaterialPrice = ceil(paintingWallsPieces) * priceList.materialPaintWallPrice
        let wallPaintMaterialRow = PriceBillRow(name: PaintWall.billSubTitle, pieces: ceil(paintingWallsPieces), unit: .squareMeter, price: wallPaintMaterialPrice)
        priceBill.addMaterials(wallPaintMaterialRow)
        
        // CeilingPaintMaterial
        let ceilingPaintMaterialPrice = ceil(paintingCeilingsPieces) * priceList.materialPaintCeilingPrice
        let ceilingPaintMaterialRow = PriceBillRow(name: PaintCeiling.billSubTitle, pieces: ceil(paintingCeilingsPieces), unit: .squareMeter, price: ceilingPaintMaterialPrice)
        priceBill.addMaterials(ceilingPaintMaterialRow)
        
        // SelfLevellingMaterial
        let selfLevellingMaterialPieces = ceil(levellingPieces/priceList.materialSelfLevellingCompoundCapacity)
        let selfLevellingMaterialPrice = selfLevellingMaterialPieces * priceList.materialSelfLevellingCompoundPrice
        let selfLevellingMaterialRow = PriceBillRow(name: SelfLevellingCompound.title, pieces: selfLevellingMaterialPieces, unit: .package, price: selfLevellingMaterialPrice)
        priceBill.addMaterials(selfLevellingMaterialRow)
        
        // FloatingFloorMaterial
        let floatingFloorMaterialPieces = ceil(floatingFloorLayingPieces*1.1)
        let floatingFloorMaterialPrice = floatingFloorMaterialPieces * priceList.materialFloatingFloorPrice
        let floatingFloorMaterialRow = PriceBillRow(name: FloatingFloor.title, pieces: floatingFloorMaterialPieces, unit: .squareMeter, price: floatingFloorMaterialPrice)
        priceBill.addMaterials(floatingFloorMaterialRow)
        
        // SkirtingBoardMaterial
        let skirtingBoardMaterialPieces = skirtingFloatingFloorPieces
        let skirtingBoardMaterialPrice = skirtingBoardMaterialPieces * priceList.materialSkirtingBoardPrice
        let skirtingBoardMaterialRow = PriceBillRow(name: SkirtingBoard.title, pieces: skirtingBoardMaterialPieces, unit: .basicMeter, price: skirtingBoardMaterialPrice)
        priceBill.addMaterials(skirtingBoardMaterialRow)
                
        // SiliconeMaterial
        let siliconeMaterialPieces = ceil(siliconizationPieces/priceList.materialSiliconeCapacity)
        let siliconeMaterialPrice = siliconeMaterialPieces * priceList.materialSiliconePrice
        let siliconeMaterialRow = PriceBillRow(name: Silicone.title, pieces: siliconeMaterialPieces, unit: .package, price: siliconeMaterialPrice)
        priceBill.addMaterials(siliconeMaterialRow)
        
        // TilingMaterial
        let tilingMaterialPrice = ceil(tilingCeramicPieces) * priceList.materialTilesPrice
        let tilingMaterialMaterialRow = PriceBillRow(name: Tiles.billSubTitle, pieces: ceil(tilingCeramicPieces), unit: .squareMeter, price: tilingMaterialPrice)
        priceBill.addMaterials(tilingMaterialMaterialRow)
        
        // PavingMaterial
        let pavingMaterialPrice = ceil(pavingCeramicPieces) * priceList.materialPavingsPrice
        let pavingMaterialMaterialRow = PriceBillRow(name: Pavings.billSubTitle, pieces: ceil(pavingCeramicPieces), unit: .squareMeter, price: pavingMaterialPrice)
        priceBill.addMaterials(pavingMaterialMaterialRow)
        
        // SanitaryMaterial
        priceBill.addMaterials(cornerValveCountAndMaterial)
        priceBill.addMaterials(standFaucetCountAndMaterial)
        priceBill.addMaterials(wallFaucetCountAndMaterial)
        priceBill.addMaterials(concealedFaucetCountAndMaterial)
        priceBill.addMaterials(combiToiletCountAndMaterial)
        priceBill.addMaterials(concealedToiletCountAndMaterial)
        priceBill.addMaterials(sinkCountAndMaterial)
        priceBill.addMaterials(sinkWithCabinetCountAndMaterial)
        priceBill.addMaterials(showerAndMaterial)
        priceBill.addMaterials(bathtubAndMaterial)
        priceBill.addMaterials(installationOfGutterAndMaterial)
        priceBill.addMaterials(urinalMaterial)
        priceBill.addMaterials(bathScreenMaterial)
        priceBill.addMaterials(mirrorMaterial)
        
        // WindowMaterial
        let windowMaterialPieces = Double(room.associatedWindowInstallations.count)
        let windowMaterialPrice = room.associatedWindowInstallations.reduce(0.0, { $0 + $1.pricePerWindow })
        let windowMaterialRow = PriceBillRow(name: WindowMaterial.title, pieces: windowMaterialPieces, unit: WindowMaterial.unit, price: windowMaterialPrice)
        priceBill.addMaterials(windowMaterialRow)
        
        // DoorJambMaterial
        let doorJambMaterialPrice = installationOfLinedDoorFramePieces * (room.associatedInstallationOfDoorJambss.first?.pricePerDoorJamb ?? 1.00)
        let doorJambMaterialRow = PriceBillRow(name: DoorJamb.title, pieces: installationOfLinedDoorFramePieces, unit: DoorJamb.unit, price: doorJambMaterialPrice)
        priceBill.addMaterials(doorJambMaterialRow)
        
        // CustomMaterials
        for customMaterial in room.associatedCustomMaterials {
            
            let customMaterialTitlePreCursor = customMaterial.title == nil ? String(localized: "Custom Material") : customMaterial.title ?? ""
            let customMaterialTitle = customMaterialTitlePreCursor.isEmpty ? String(localized: "Custom Material") : customMaterialTitlePreCursor
            
            let customMaterialRow = PriceBillRow(name: customMaterialTitle, pieces: customMaterial.numberOfUnits, unit: UnitsOfMeasurement.parse(customMaterial.unit), price: customMaterial.numberOfUnits * customMaterial.pricePerUnit)
            
            priceBill.addMaterials(customMaterialRow)
            
        }
        
        // AuxilaryMaterial
        let auxilaryMaterialPrice = priceBill.materialsPrice * (priceList.materialAuxiliaryAndFasteningPrice/100)
        let auxilaryMaterialRow = PriceBillRow(name: AuxiliaryAndFasteningMaterial.title, pieces: priceList.materialAuxiliaryAndFasteningPrice, unit: .percentage, price: auxilaryMaterialPrice)
        priceBill.addMaterials(auxilaryMaterialRow)
        
        // MARK: - OTHERS -
        // CommuteExpenses
        let commuteExpensesPieces = room.commuteLength * room.daysInWork
        let commuteExpensesPrice = commuteExpensesPieces * priceList.othersCommutePrice
        let commuteExpensesRow = PriceBillRow(name: Commute.title, pieces: commuteExpensesPieces, unit: .kilometer, price: commuteExpensesPrice)
        priceBill.addOthers(commuteExpensesRow)
        
        
        // Scaffoldings
        let scaffoldingsPieces = room.associatedScaffoldings.reduce(0.0) { $0 + $1.area }
        let scaffoldingsDays = room.associatedScaffoldings.reduce(0.0) { $0 + $1.numberOfDays }
        let scaffoldingsPrice = priceList.othersScaffoldingPrice * scaffoldingsPieces * scaffoldingsDays
        let scaffoldingsRow = PriceBillRow(name: Scaffolding.title, pieces: scaffoldingsDays, unit: Scaffolding.unit, price: scaffoldingsPrice)
        priceBill.addOthers(scaffoldingsRow)
        
        let scaffoldingsAssemblyPrice = priceList.othersScaffoldingAssemblyAndDisassemblyPrice * scaffoldingsPieces
        let scaffoldingsAssemblyRow = PriceBillRow(name: ScaffoldingAssemblyAndDisassembly.billTitle, pieces: scaffoldingsPieces, unit: ScaffoldingAssemblyAndDisassembly.unit, price: scaffoldingsAssemblyPrice)
        priceBill.addOthers(scaffoldingsAssemblyRow)
        
        // CoreDrill
        let coreDrillPieces = room.associatedCoreDrills.reduce(0.0) { $0 + $1.count }
        let coreDrillPrice = priceList.othersCoreDrillRentalPrice * coreDrillPieces
        let coreDrillRow = PriceBillRow(name: CoreDrill.title, pieces: coreDrillPieces, unit: CoreDrill.unit, price: coreDrillPrice)
        priceBill.addOthers(coreDrillRow)
        
        // ToolRental
        let newToolRentalPieces = room.associatedToolRentals.reduce(0.0) { $0 + $1.count }
        let oldToolRentalPieces = room.toolRental
        let toolRentalPieces = newToolRentalPieces + oldToolRentalPieces
        let toolRentalPrice = toolRentalPieces * priceList.othersToolRentalPrice
        let toolRentalRow = PriceBillRow(name: ToolRental.title, pieces: toolRentalPieces, unit: ToolRental.unit, price: toolRentalPrice)
        priceBill.addOthers(toolRentalRow)
        
        return priceBill
        
    }
    
    func projectPriceBillCalculations(project: Project, priceList: PriceList) -> ProjectPriceBill {
        
        var projectPriceBill: ProjectPriceBill = ProjectPriceBill()
        
        for room in project.associatedRooms {
            
            let roomPriceBill = roomPriceBillCalculation(room: room, priceList: priceList)
            
            projectPriceBill.rooms.append(RoomBillRow(name: roomPriceBill.roomName, price: roomPriceBill.priceWithoutVat))
            
        }
        
        return projectPriceBill
        
    }
    
    
    func projectPriceBills(project: Project, priceList: PriceList) -> PriceBill {
        
        var projectBills: [PriceBill] = []
        
        for room in project.associatedRooms {
            
            let roomPriceBill = roomPriceBillCalculation(room: room, priceList: priceList)
            
            projectBills.append(roomPriceBill)
            
        }
        
        return joinDuplicatePriceBills(projectBills)
        
    }
    
    private func joinDuplicatePriceBills(_ priceBills: [PriceBill]) -> PriceBill {
        // Initialize an empty PriceBill
        var consolidatedBill = PriceBill(roomName: "All Rooms Consolidated", works: [], materials: [], others: [])

        // Helper function to consolidate rows
        func consolidateRows(from array: [PriceBillRow]) -> [PriceBillRow] {
            var consolidatedRows: [PriceBillRow] = []
            
            for row in array {
                if let index = consolidatedRows.firstIndex(where: { $0.name == row.name && $0.unit == row.unit }) {
                    consolidatedRows[index].joinPriceBillRow(with: row)
                } else {
                    consolidatedRows.append(row)
                }
            }
            
            return consolidatedRows
        }

        // Consolidate all works, materials, and others from all price bills
        for bill in priceBills {
            consolidatedBill.works += bill.works
            consolidatedBill.materials += bill.materials
            consolidatedBill.others += bill.others
        }

        // Apply consolidation to each category
        consolidatedBill.works = consolidateRows(from: consolidatedBill.works)
        consolidatedBill.materials = consolidateRows(from: consolidatedBill.materials)
        consolidatedBill.others = consolidateRows(from: consolidatedBill.others)

        // Recalculate prices
        consolidatedBill.worksPrice = consolidatedBill.works.reduce(0) { $0 + $1.price }
        consolidatedBill.materialsPrice = consolidatedBill.materials.reduce(0) { $0 + $1.price }
        consolidatedBill.othersPrice = consolidatedBill.others.reduce(0) { $0 + $1.price }

        return consolidatedBill
    }

    
}
