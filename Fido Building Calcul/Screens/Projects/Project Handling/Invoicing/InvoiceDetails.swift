//
//  InvoiceDetails.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//

import SwiftUI

struct IdentifiableInvoiceMissingValue: Identifiable {
    let id = UUID()
    let value: any InvoiceMissingValue
}

protocol InvoiceMissingValue: Identifiable {
    var title: LocalizedStringKey { get }
}
 
struct InvoiceDetails {
    
    var project: Project
    var contractor: Contractor?
    var client: Client?
    var priceWithoutVAT: Double?
    var cumulativeVat: Double?
    var number: Int64?
    var dateOfDispatch = Date.now
    var paymentType: PaymentType = .bankTransfer
    var note: String = ""
    var dateCreated = Date.now
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
    
    var missingValues: [IdentifiableInvoiceMissingValue] {
        
        var values: [IdentifiableInvoiceMissingValue] = []
        
        if let contractor = self.contractor {
            if contractor.logo?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.logo))
            }
            if contractor.name?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.name))
            }
            if contractor.email?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.email))
            }
            if contractor.phone?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.phone))
            }
            if contractor.street?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.street))
            }
            if contractor.city?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.city))
            }
            if contractor.postalCode?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.postalCode))
            }
            if contractor.country?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.country))
            }
            if contractor.businessID?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.businessID))
            }
            if contractor.taxID?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.taxID))
            }
            if contractor.vatRegistrationNumber?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.vatRegistrationNumber))
            }
            if contractor.bankAccountNumber?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.bankAccountNumber))
            }
            if contractor.swiftCode?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.swiftCode))
            }
            if contractor.signature?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ContractorValues.signature))
            }
        } else {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.contractor))
        }
        
        if let client = self.client {
            
            if client.name?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ClientValues.name))
            }
            if client.street?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ClientValues.street))
            }
            if client.city?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ClientValues.city))
            }
            if client.postalCode?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ClientValues.postalCode))
            }
            if client.country?.isEmpty ?? true {
                values.append(IdentifiableInvoiceMissingValue(value: ClientValues.country))
            }
            
            if ClientType(rawValue: client.type ?? "corporation") == .corporation {
                if client.businessID?.isEmpty ?? true {
                    values.append(IdentifiableInvoiceMissingValue(value: ClientValues.businessID))
                }
                if client.taxID?.isEmpty ?? true {
                    values.append(IdentifiableInvoiceMissingValue(value: ClientValues.taxID))
                }
                if client.vatRegistrationNumber?.isEmpty ?? true {
                    values.append(IdentifiableInvoiceMissingValue(value: ClientValues.vatRegistrationNumber))
                }
            }
                
        } else {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.client))
        }
        
        if self.priceWithoutVAT ?? 0.0 == 0.0 {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.priceWithoutVAT))
        }
        if self.cumulativeVat ?? 0.0 == 0.0 {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.cumulativeVAT))
        }
        if self.number ?? 0 == 0 {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.number))
        }
        if self.invoiceItems.isEmpty { values.append(IdentifiableInvoiceMissingValue(value:InvoiceValues.invoiceItems))
        }
        if self.number ?? 0 < 2000000 {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.incorrectNumberFormat))
        }
        if self.isNumberUsed {
            values.append(IdentifiableInvoiceMissingValue(value: InvoiceValues.numberAlreadyInUse))
        }
        
                                                     
        return values
        
    }
    
    var isValidIBAN: Bool {
        if let iban = self.contractor?.bankAccountNumber {
            let IBAN = iban.replacingOccurrences(of: " ", with: "")
            var a = IBAN.utf8.map{ $0 }
            while a.count < 4 {
                a.append(0)
            }
            let b = a[4..<a.count] + a[0..<4]
            let c = b.reduce(0) { (r, u) -> Int in
                let i = Int(u)
                return i > 64 ? (100 * r + i - 55) % 97: (10 * r + i - 48) % 97
            }
            return c == 1
        }
        return false
    }
    
    var inSEPACountry: Bool {
        
        let sepaCountries: Set<String> = [
                    "AT", "BE", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FR", "DE", "GR", "HU", "IS", "IE", "IT",
                    "LV", "LI", "LT", "LU", "MT", "MC", "NL", "NO", "PL", "PT", "RO", "SM", "SK", "SI", "ES", "SE",
                    "CH", "GB"
                ]
        
        let currentLocale = Locale.current.region?.identifier ?? ""
        print("inSEPACountry", sepaCountries.contains(currentLocale))
        return sepaCountries.contains(currentLocale)
        
    }
    
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
            let newPrice = num*invoiceItems[index].pricePerPiece
            invoiceItems[index].changePrice(to: newPrice.round)
            recalculate()
            return invoiceItems[index].pieces
        }
        
        return 0
        
    }
    
    mutating func changePriceWithoutVat(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changePrice(to: num)
            let newPricePerPiece = num/invoiceItems[index].pieces
            invoiceItems[index].changePricePerPiece(to: newPricePerPiece)
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

    
    mutating func changePricePerPiece(of id: UUID, to num: Double) -> Double {
        
        let index = invoiceItems.firstIndex{ $0.id == id }
        
        if let index {
            invoiceItems[index].changePricePerPiece(to: num)
            let newPriceWithoutVAT = num*invoiceItems[index].pieces
            invoiceItems[index].changePrice(to: newPriceWithoutVAT)
            recalculate()
            return invoiceItems[index].pricePerPiece
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
    
    func getPricePerPiece(of id: UUID) -> Double {
        let index = invoiceItems.firstIndex{ $0.id == id }
        if let index {
            return invoiceItems[index].pricePerPiece
        }
        return 0.0
    }
    
    func getPriceWithoutVAT(of id: UUID) -> Double {
        let index = invoiceItems.firstIndex{ $0.id == id }
        if let index {
            return invoiceItems[index].price
        }
        return 0.0
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
    
    var isNumberUsed: Bool {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        if let contractor = project.contractor {
            request.predicate = NSPredicate(format: "number == %@ AND toContractor == %@", argumentArray: [self.number ?? 0 as NSNumber, contractor as CVarArg])
        }
        
        request.fetchLimit = 1
        
        let fetchedInvoices = try? viewContext.fetch(request)
        
        guard let fetchedInvoices else { return false }
        
        return !fetchedInvoices.isEmpty
        
    }
    
    mutating func formatNumber() {
        // Ensure the number is an integer and convert to string
        let input = String(Int(number ?? 1))
        
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // If more than 7 characters
        if input.count > 7 {
            number = Int64("\(currentYear)001")
            return
        }
        
        // Check if the input is already in the correct format
        let regex = "^\\d{7}$"
        if let _ = input.range(of: regex, options: .regularExpression) {
            return
        }
        
        // Remove leading zeros and non-numeric characters from the input
        let sanitizedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .filter { $0.isNumber }
        
        // If input has more than 3 digits but less than 7, set it to current year + 001
        if sanitizedInput.count > 3 && sanitizedInput.count < 7 {
            number = Int64("\(currentYear)001")
            return
        }
        
        // Remove leading zeros
        //let trimmedInput = sanitizedInput.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        
        // If the sanitized input is empty, return the formatted string for the current year with 001
        guard !input.isEmpty else {
            number = Int64("\(currentYear)001")
            return
        }
        
        // Convert the sanitized input to an integer
        if let tryNumber = Int(input) {
            // Format the number with leading zeros, ensuring it has 3 digits
            let formattedNumber = String(format: "%03d", tryNumber)
            self.number = Int64("\(currentYear)\(formattedNumber)")
            return
        }
        
        // In case of any unexpected issues, return the default formatted string
        number = Int64("\(currentYear)001")
    }

    mutating func getPDFNumber() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.number, ascending: false)]
        
        let currentYear = Calendar.current.component(.year, from: Date.now)
        
        let startOfTheYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1, hour: 0, minute: 0))
        
        guard let startOfTheYear else { return }
        
        if let contractor = project.contractor {
            request.predicate = NSPredicate(format: "dateCreated >= %@ && toContractor == %@", [startOfTheYear as NSDate, contractor as CVarArg])
        }
        
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

extension InvoiceDetails {
    
    /// InvoiceDetails Extensions Regarding Receipt for Cash payment
    
    @MainActor
    var cashReceiptURL: URL? {
        if paymentType == .cash {
            return InvoicePDFCreator(self).renderCashReceipt()
        } else {
            return nil
        }
    }
    
    var titleCashReceipt: String {
        let localizedCashReceipt = NSLocalizedString("Cash Receipt", comment: "")
        
        return "\(localizedCashReceipt) \(invoiceNumber)"
    }
    
    
}

struct InvoiceItem: Identifiable {
    
    var id: UUID
    var title: LocalizedStringKey
    var pieces: Double
    var pricePerPiece: Double
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
        self.pricePerPiece = round(priceBillRow.price/priceBillRow.pieces*100)/100
        self.unit = priceBillRow.unit
        self.vat = vat
        self.category = category
        self.active = true
        
    }
    
    mutating func changePricePerPiece(to num: Double) {
        self.pricePerPiece = num
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
