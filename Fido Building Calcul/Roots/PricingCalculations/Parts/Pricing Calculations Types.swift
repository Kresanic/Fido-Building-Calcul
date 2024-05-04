//
//  PricingPriceTypes.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

struct ProjectPriceBill: Identifiable {
    
    let id = UUID()
    var rooms: [RoomBillRow] = []
    var priceWithoutVat: Double { rooms.reduce(0.0, { $0 + $1.price }) }
    
}

struct RoomBillRow: Identifiable {
    
    let id = UUID()
    var name: String
    var price: Double
    
}

struct PDFProjectPriceBill: Identifiable {
    
    let id = UUID()
    var projectName: String
    var VATPercentage: Double
    var works: [PriceBillRow] = []
    var worksPrice: Double = 0.0
    var materials: [PriceBillRow] = []
    var materialsPrice: Double = 0.0
    var others: [PriceBillRow] = []
    var othersPrice: Double = 0.0
    var priceWithoutVat: Double { worksPrice + materialsPrice + othersPrice }
    var worksCount: Int { works.count > 1  ?  works.count - 1 : works.count  }
    
    mutating func addWorks(_ newPriceBillRow: PriceBillRow) {
        if newPriceBillRow.price > 0.0 {
            if let indexNum = works.firstIndex(where: { priceBillRow in
                priceBillRow.name == newPriceBillRow.name
            }) {
                if newPriceBillRow.name == AuxiliaryAndFinishingWork.title{
                    works[indexNum].joinAuxilary(with: newPriceBillRow)
                    worksPrice += newPriceBillRow.price
                    works.rearrangeToLast(fromIndex: indexNum)
                } else {
                    works[indexNum].joinPriceBillRow(with: newPriceBillRow)
                    worksPrice += newPriceBillRow.price
                }
            } else {
                self.works.append(newPriceBillRow)
                self.worksPrice += newPriceBillRow.price
            }
        }
    }
    
    mutating func addMaterials(_ newPriceBillRow: PriceBillRow) {
        if newPriceBillRow.price > 0.0 {
            if let indexNum = materials.firstIndex(where: { priceBillRow in
                priceBillRow.name == newPriceBillRow.name
            }) {
                
                if newPriceBillRow.name == AuxiliaryAndFasteningMaterial.title{
                    materials[indexNum].joinAuxilary(with: newPriceBillRow)
                    materialsPrice += newPriceBillRow.price
                    materials.rearrangeToLast(fromIndex: indexNum)
                } else {
                    materials[indexNum].joinPriceBillRow(with: newPriceBillRow)
                    materialsPrice += newPriceBillRow.price
                }
            } else {
                self.materials.append(newPriceBillRow)
                self.materialsPrice += newPriceBillRow.price
            }
        }
    }
    
    mutating func addOthers(_ newPriceBillRow: PriceBillRow) {
        if newPriceBillRow.price > 0.0 {
            if let indexNum = others.firstIndex(where: { priceBillRow in
                priceBillRow.name == newPriceBillRow.name
            }) {
                others[indexNum].joinPriceBillRow(with: newPriceBillRow)
                othersPrice += newPriceBillRow.price
            } else {
                self.others.append(newPriceBillRow)
                self.othersPrice += newPriceBillRow.price
            }
        }
    }
    
}

struct PriceBill: Identifiable {
    
    let id = UUID()
    var roomName: String
    var works: [PriceBillRow]
    var worksPrice: Double = 0.0
    var materials: [PriceBillRow]
    var materialsPrice: Double = 0.0
    var others: [PriceBillRow]
    var othersPrice: Double = 0.0
    var priceWithoutVat: Double { worksPrice + materialsPrice + othersPrice }
    var worksCount: Int { works.count > 1  ?  works.count - 1 : works.count  }
    
    mutating func addWorks(_ priceBillRow: PriceBillRow) {
        if priceBillRow.price > 0.0 {
            self.works.append(priceBillRow)
            self.worksPrice += priceBillRow.price
        }
    }
    
    mutating func addMaterials(_ priceBillRow: PriceBillRow) {
        if priceBillRow.price > 0.0 {
            self.materials.append(priceBillRow)
            self.materialsPrice += priceBillRow.price
        }
    }
    
    mutating func addOthers(_ priceBillRow: PriceBillRow) {
        if priceBillRow.price > 0.0 {
            self.others.append(priceBillRow)
            self.othersPrice += priceBillRow.price
        }
    }
    
}

public struct PriceBillRow: Identifiable {
    
    public var id = UUID()
    public var name: LocalizedStringKey
    public var pieces: Double
    public var unit: UnitsOfMeasurement
    public var price: Double
    
    public init(name: String, pieces: Double, unit: UnitsOfMeasurement, price: Double) {
        self.name = LocalizedStringKey(name)
        self.pieces = pieces
        self.unit = unit
        self.price = price
    }
    
    public init(name: LocalizedStringKey, pieces: Double, unit: UnitsOfMeasurement, price: Double) {
        self.name = name
        self.pieces = pieces
        self.unit = unit
        self.price = price
    }
    
    mutating func joinPriceBillRow(with priceBillRow: PriceBillRow) {
        if name == priceBillRow.name {
            pieces += priceBillRow.pieces
            price += priceBillRow.price
        }
    }
    
    mutating func joinAuxilary(with priceBillRow: PriceBillRow) {
        if name == priceBillRow.name {
            price += priceBillRow.price
        }
    }
    
}

//
//func joinPriceRow(with priceBillRow: PriceBillRow) -> PriceBillRow? {
//    
//    if self.name == priceBillRow.name && self.unit == priceBillRow.unit {
//        
//        var pBR = priceBillRow
//        
//        pBR.price = pBR.price + price
//        pBR.pieces = pBR.pieces + pieces
//        
//        return pBR
//    }
//    
//    return nil
//    
//}
