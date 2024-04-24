//
//  InvoiceBuilderViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/04/2024.
//

import SwiftUI


@MainActor final class InvoiceBuilderViewModel: ObservableObject {
    
    @Published var invoiceItems: [InvoiceItem] = []
    @Published var madeChanges = false
    @Published var dialogWindow: Dialog?
    
    func populateInvoiceItems(with project: Project) {
        
        guard let priceList = project.toPriceList else { return }
        
        let projectVat = project.vatOfProject
        
        let calculations = PricingCalculations()
        
        let projectPriceBills = calculations.projectPriceBills(project: project, priceList: priceList)
        
        for priceBill in projectPriceBills {
            
            for work in priceBill.works {
                invoiceItems.append(.init(pBR: work, category: .work, vat: projectVat))
            }
            
            for material in priceBill.materials {
                invoiceItems.append(.init(pBR: material, category: .material, vat: projectVat))
            }
            
            for other in priceBill.others {
                invoiceItems.append(.init(pBR: other, category: .other, vat: projectVat))
            }
            
        }
        
    }
    
    func changeTitle(of id: UUID, to str: String) -> String {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changeTitle(to: str)
            return NSLocalizedString(invoiceItems[index].title.stringKey ?? "", comment: "")
        }
        
        return ""
        
    }
    
    func changePieces(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changePieces(to: num)
            return invoiceItems[index].pieces
        }
        
        return 0
        
    }
    
    func changePrice(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changePrice(to: num)
            return invoiceItems[index].price
        }
        
        return 0
        
    }
    
    func changeVat(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changeVat(to: num)
            return invoiceItems[index].vat
        }
        
        return 0
        
    }
    
    func toggleVisibility(of id: UUID, from state: Bool) -> Bool {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].toggleVisibility()
            return invoiceItems[index].active
        }
        
        return !state
        
    }
    
}


struct InvoiceItem: Identifiable {
    
    init(pBR priceBillRow: PriceBillRow, category: InvoiceItemCategory, vat: Double) {
        
        self.id = UUID()
        self.title = priceBillRow.name
        self.pieces = priceBillRow.pieces
        self.price = round(priceBillRow.price*100)/100
        self.unit = priceBillRow.unit
        self.vat = vat
        self.category = category
        self.active = true
        
    }
    
    var id: UUID
    var title: LocalizedStringKey
    var pieces: Double
    var price: Double
    var vat: Double
    var unit: UnitsOfMeasurement
    var category: InvoiceItemCategory
    var active: Bool
    
    mutating func changeTitle(to str: String) {
        self.title = LocalizedStringKey(str)
    }
    
    mutating func changePieces(to num: Double) {
        self.pieces = num
    }
    
    mutating func changePrice(to num: Double) {
        self.price = num
    }
    
    mutating func changeVat(to num: Double) {
        self.vat = num
    }
    
    mutating func toggleVisibility() {
        self.active.toggle()
    }
    
}


enum InvoiceItemCategory { case work, material, other }
