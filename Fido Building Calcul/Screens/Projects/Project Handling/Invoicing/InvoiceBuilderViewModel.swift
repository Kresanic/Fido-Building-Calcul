//
//  InvoiceBuilderViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/04/2024.
//

import SwiftUI
import CoreData


@MainActor final class InvoiceBuilderViewModel: ObservableObject {
    
    @Published var invoiceItems: [InvoiceItem] = []
    @Published var invoiceDetails: InvoiceDetails?
    @Published var madeChanges = false
    @Published var dialogWindow: Dialog?
    
    func populateInvoiceItems(with project: Project) {
        
        invoiceDetails = InvoiceDetails(project: project)
        
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


struct InvoiceDetails {
    
    var contractor: Contractor?
    var project: Project?
    var client: Client?
    var price: Double?
    var number: Int64?
    let dateCreated = Date.now
    
    init(project prjct: Project?) {
        self.project = prjct
        self.contractor = prjct?.toContractor
        self.client = prjct?.toClient
        getPDFNumber()
    }
    
    var invoiceNumber: String {
        
        let year = Calendar.current.component(.year, from: Date.now)
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        
        let numberAsString = formatter.string(from: (number ?? 1) as NSNumber)
        
        return "\(year)\(numberAsString ?? "001")"
        
    }
    
    mutating func getPDFNumber() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        let currentYear = Calendar.current.component(.year, from: Date.now)
        
        let startOfTheYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1, hour: 0, minute: 0))
        
        guard let startOfTheYear else { return }
        
        request.predicate = NSPredicate(format: "dateCreated >= %@", startOfTheYear as NSDate)
        
        request.fetchLimit = 1; #warning("Check")
        
        guard let invoices = try? viewContext.fetch(request) else { return }
        
        if invoices.isEmpty { number = 1 }
        
        guard let lastNumber = invoices.first?.number else { return }
        
        number =  lastNumber + 1
        
    }
    
    var getQRCodeDetails: String? {
        
        guard
            let contractor,
            let swiftCode = contractor.swiftCode,
            let name = contractor.name,
            let iban = contractor.bankAccountNumber,
            let price,
            let number
        else { return nil }
        //TODO: Try ST: B2B and ID also idk
        
        return """
        BCS
        002
        2
        STC
        \(swiftCode)
        \(name)
        \(iban)
        EUR\(price)"
        
        
        \(invoiceNumber)
        """
        
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
