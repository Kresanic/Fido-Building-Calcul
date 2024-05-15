//
//  InvoiceDetails.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//

import SwiftUI

struct InvoiceDetails {
    
    var project: Project
    var contractor: Contractor?
    var client: Client?
    var priceWithoutVAT: Double?
    var cumulativeVat: Double?
    var number: Int64?
    let dateCreated = Date.now
    var invoiceItems: [InvoiceItem] = []
    
    
    
    init(project prjct: Project) {
        self.project = prjct
        self.contractor = prjct.toContractor
        self.client = prjct.toClient
        getPDFNumber()
        populateInvoiceItems(with: prjct)
    }
    
}

extension InvoiceDetails {
    
    /// Extension regarding mutating and retrieving invoice items
    
    var unPriceWithoutVAT: Double {
        round((priceWithoutVAT ?? 0.00)*100)/100
    }
    
    var unCumulativeVat: Double {
        round((cumulativeVat ?? 0.00)*100)/100
    }
    
    var totalPrice: Double {
        unPriceWithoutVAT + unCumulativeVat
    }

    var workItems: [InvoiceItem] { invoiceItems.filter {$0.category == .work} }
    
    var materialItems: [InvoiceItem] { invoiceItems.filter {$0.category == .material} }
    
    var otherItems: [InvoiceItem] { invoiceItems.filter {$0.category == .other} }
    
    mutating private func populateInvoiceItems(with project: Project) {
        
        guard let priceList = project.toPriceList else { return }
        
        let projectVat = project.vatOfProject
        
        let calculations = PricingCalculations()
        
        let projectPriceBills = calculations.projectPriceBills(project: project, priceList: priceList)
        
        loadPriceBills(projectPriceBills, projectVat: projectVat)
        
    }
    
    mutating private func loadPriceBills(_ priceBill: PriceBill, projectVat: Double) {
            
        for work in priceBill.works {
            invoiceItems.append(.init(pBR: work, category: .work, vat: projectVat))
        }
        
        for material in priceBill.materials {
            invoiceItems.append(.init(pBR: material, category: .material, vat: projectVat))
        }
        
        for other in priceBill.others {
            invoiceItems.append(.init(pBR: other, category: .other, vat: projectVat))
        }
        
        recalculate()
        
    }
    
    mutating private func recalculate() {
     
        priceWithoutVAT = invoiceItems.reduce(0.0) {
            if $1.active {
                return $0 + $1.price
            }
            
            return $0
        }
        
        cumulativeVat = invoiceItems.reduce(0.0) {
            if $1.active {
                return $0 + ($1.price * ($1.vat/100))
            }
            
            return $0
        }
        
    }

    mutating func changeTitle(of id: UUID, to str: String) -> String {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changeTitle(to: str)
            return NSLocalizedString(invoiceItems[index].title.stringKey ?? "", comment: "")
        }
        
        return ""
        
    }
    
    mutating func changePieces(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changePieces(to: num)
            recalculate()
            return invoiceItems[index].pieces
        }
        
        return 0
        
    }
    
    mutating func changePrice(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changePrice(to: num)
            recalculate()
            return invoiceItems[index].price
        }
        
        return 0
        
    }
    
    mutating func changeVat(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changeVat(to: num)
            recalculate()
            return invoiceItems[index].vat
        }
        
        return 0
        
    }
    
    mutating func toggleVisibility(of id: UUID, from state: Bool) -> Bool {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].toggleVisibility()
            recalculate()
            return invoiceItems[index].active
        }
        
        return !state
        
    }
    
}

extension InvoiceDetails {
    
    /// Extension regarding PDF creation
    
    @MainActor
    var pdfURL: URL {
        return InvoicePDFCreator(self).render()
    }
    
    var title: String {
        let localizedInvoice = NSLocalizedString("Invoice", comment: "")
        
        return "\(localizedInvoice) \(invoiceNumber)"
    }
    
    var invoiceNumber: String {
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        
        let numberAsString = formatter.string(from: (number ?? 1) as NSNumber)
        
        return "\(numberAsString ?? "001")"
        
    }
    
    mutating func getPDFNumber() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        let currentYear = Calendar.current.component(.year, from: Date.now)
        
        let startOfTheYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1, hour: 0, minute: 0))
        
        guard let startOfTheYear else { return }
        
        request.predicate = NSPredicate(format: "dateCreated >= %@ && toContractor == %@", [startOfTheYear as NSDate, project.toContractor! as CVarArg])
        
        request.fetchLimit = 1; #warning("Check")
        
        guard let invoices = try? viewContext.fetch(request) else { return }
        
        if invoices.isEmpty { number = Int64("\(currentYear)001") }
        
        guard let lastNumber = invoices.first?.number else { return }
        
        number =  lastNumber + 1
        
    }
    
    var getQRCodeDetails: String? {
        
        guard
            let contractor,
            let swiftCode = contractor.swiftCode,
            let name = contractor.name,
            let iban = contractor.bankAccountNumber?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),
            let _ = cumulativeVat,
            let _ = priceWithoutVAT
        else { return nil }
        //TODO: Alert when details are missing and localize
        
        //TODO: Try ST: B2B and ID also idk
        
        return """
        BCD
        002
        1
        SCT
        \(swiftCode)
        \(name)
        \(iban)
        EUR\(totalPrice)
        
        \(invoiceNumber)
        """
    }
    
    
}

struct InvoiceItem: Identifiable {
    
    var id: UUID
    var title: LocalizedStringKey
    var pieces: Double
    var price: Double
    var vat: Double
    var unit: UnitsOfMeasurement
    var category: InvoiceItemCategory
    var active: Bool
    
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
    
    mutating func joinInvoiceItem(with invoiceItem: Self) {
        if self.title == invoiceItem.title && self.unit == invoiceItem.unit {
            if self.unit != .percentage {
                pieces += invoiceItem.pieces
            }
            price += invoiceItem.price
        }
    }
    
}

enum InvoiceItemCategory { case work, material, other }

