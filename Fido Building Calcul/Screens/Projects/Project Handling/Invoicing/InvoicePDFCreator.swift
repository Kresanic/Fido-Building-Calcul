//
//  InvoicePDFCreator.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/04/2024.
//

import SwiftUI
import PDFKit
import CoreData

@MainActor final class InvoicePDFCreator {
    
    @AppStorage("invoiceMaturityDuration") var invoiceMaturityDuration: Int = 30
    @AppStorage("invoiceNote") var invoiceNote: String = ""
    
    let invoiceDetails: InvoiceDetails
    let invoiceItems: [InvoiceItem]
    
    init(_ invoiceDetails: InvoiceDetails) {
        self.invoiceDetails = invoiceDetails
        self.invoiceItems = invoiceDetails.invoiceItems
    }
    
    func render() -> URL {
        
        let pdfContent = contentPDF()
        
        let renderer = ImageRenderer(content: pdfContent)
        
        let url = URL.documentsDirectory.appending(path: "\(invoiceDetails.title).pdf")
        
        renderer.render { size, context in
            
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
    
        return url
    
    }
    
    func contentPDF() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    let localizedInvoice = NSLocalizedString("Invoice", comment: "")
                    
                    Text("\(localizedInvoice) \(invoiceDetails.invoiceNumber)")
                        .font(.system(size: 25, weight: .semibold))
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(Color.brandBlack)
                    
                    let localizedPriceOffer = NSLocalizedString("Price Offer", comment: "")
                
                    Text("\(localizedPriceOffer) \(invoiceDetails.project.projectNumber)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                    
                    Spacer()
                    
                    if let client = invoiceDetails.client {
                        
                        VStack(alignment: .leading) {
                            
                            Text(NSLocalizedString("Customer", comment: ""))
                                .font(.system(size: 13, weight: .bold))
                            
                            PDFClientInfoView(client: client)
                            
                        }
                        
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                        
                    if let imageData = invoiceDetails.contractor?.logo, let logo =  UIImage(data: imageData)  {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175)
                            .clipShape(.rect(cornerRadius: 10, style: .continuous))
                            .padding(.bottom, 10)
                    }
                    
                    Spacer()
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Date of issue", comment: ""), value: invoiceDetails.dateCreated.formatted(date: .numeric, time: .omitted), spaced: true)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Maturity date", comment: ""), value: invoiceDetails.dateCreated.addingTimeInterval(TimeInterval(invoiceMaturityDuration*24*60*60)).formatted(date: .numeric, time: .omitted), spaced: true)
                    
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Variable symbol", comment: ""), value: invoiceDetails.invoiceNumber, spaced: true)
                        .padding(.top, 5)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Date of dispatch", comment: ""), value: invoiceDetails.dateOfDispatch.formatted(date: .numeric, time: .omitted), spaced: true)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Payment type", comment: ""), value: NSLocalizedString(invoiceDetails.paymentType.title.stringKey ?? "", comment: ""), spaced: true)
                    
                }.frame(width: 175)
                
            }.frame(maxHeight: 200)
            
            if let projectSumUp = projectSumUp(invoiceDetails) {
                
                if let contractor = invoiceDetails.contractor, let bankNumber = contractor.bankAccountNumber {
                    
                    HStack(spacing: 2) {
                        
                        PDFInvoiceSummaryBubble(title: NSLocalizedString("Bank Account Number", comment: ""), value: bankNumber)
                        
                        PDFInvoiceSummaryBubble(title: NSLocalizedString("Variable symbol", comment: ""), value: invoiceDetails.invoiceNumber)
                        
                        PDFInvoiceSummaryBubble(title: NSLocalizedString("Maturity date", comment: ""), value: Date.now.addingTimeInterval(TimeInterval(invoiceMaturityDuration*24*60*60)).formatted(date: .numeric, time: .omitted))
                        
                        PDFInvoiceSummaryBubble(title: NSLocalizedString("Amount to be paid", comment: ""), value: invoiceDetails.totalPrice.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                        
                    }.padding(.vertical, 15)
                    
                }
                
                HStack {
                    
                    Text(NSLocalizedString("Description", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                    
                    Spacer()
                    
                    Text(NSLocalizedString("Count", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 60, alignment: .trailing)
                    
                    Text(NSLocalizedString("Price per unit", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.center)
                        .frame(width: 70, alignment: .trailing)
                        .lineLimit(2)
                    
                    Text(NSLocalizedString("VAT(%)", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 60, alignment: .trailing)
                    
                    Text(NSLocalizedString("VAT", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 80, alignment: .trailing)
                    
                    Text(NSLocalizedString("Price", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 80, alignment: .trailing)
                    
                }
                
                Rectangle()
                    .foregroundStyle(Color.brandBlack)
                    .frame(maxWidth: .infinity, maxHeight: 1).padding(.vertical, 4)
                
                if !projectSumUp.works.isEmpty {
                    Text(NSLocalizedString("Work", comment: ""))
                        .font(.system(size: 10, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 2)
                }
                
                ForEach(projectSumUp.works) { PDFInvoiceRowView($0) }
                
                if !projectSumUp.materials.isEmpty {
                    Text(NSLocalizedString("Material", comment: ""))
                        .font(.system(size: 10, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                        .padding(.bottom, 2)
                }
                
                ForEach(projectSumUp.materials) { PDFInvoiceRowView($0) }
                
                if !projectSumUp.others.isEmpty {
                    Text(NSLocalizedString("Others", comment: ""))
                        .font(.system(size: 10, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                        .padding(.bottom, 2)
                }
                
                ForEach(projectSumUp.others) { PDFInvoiceRowView($0) }
                
                Rectangle()
                    .foregroundStyle(Color.brandBlack)
                    .frame(maxWidth: .infinity, maxHeight: 1).padding(.vertical, 4)
                
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        if invoiceDetails.isValidIBAN, invoiceDetails.inSEPACountry {
                            if let qrCode = generateQRCode(invoiceDetails: invoiceDetails) {
                                VStack(spacing: 3) {
                                    
                                    Image(uiImage: qrCode)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .padding(.top, 30)
                                    
                                    Text(NSLocalizedString("Scan to Pay!", comment: ""))
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundStyle(.brandBlack)
                                    
                                }
                            }
                            
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        
                        PDFInvoiceTotalPriceView(invoiceDetails)
                        
                        if let imageData = invoiceDetails.contractor?.signature, let signature =  UIImage(data: imageData) {
                            VStack(alignment: .leading, spacing: 3) {
                                
                                Text(NSLocalizedString("Issued by:", comment: ""))
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.brandBlack)
                                
                                Image(uiImage: signature)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140, height: 80)
                                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                            }.padding(.top, 10)
                        }
                        
                    }
                    
                }
                
                Spacer()
                
                Text(invoiceNote)
                    .font(.system(size: 10))
                    .foregroundStyle(.brandBlack)
                    .padding(.bottom, 10)
                
            } else { Text(NSLocalizedString("PDF could not be created.", comment: "")) }
            
            if let contractor = invoiceDetails.contractor {
                PDFContractorInfoView(contractor: contractor)
            }
            
            Text(NSLocalizedString("Created using Fido Building Calcul app.", comment: ""))
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
            
        }.padding(.horizontal, 35)
            .padding(.vertical, 35)
            .frame(width: 630)
            .frame(minHeight: 891, alignment: .top)
        
    }
    
    func projectSumUp(_ invoiceDetail: InvoiceDetails) -> PDFInvoicePriceBill? {
            
        var pDFInvoicePriceBill: PDFInvoicePriceBill = PDFInvoicePriceBill()
            
        for work in invoiceDetail.workItems {
            if work.active {
                pDFInvoicePriceBill.addWorks(work)
            }
        }
        
        for material in invoiceDetail.materialItems {
            if material.active {
                pDFInvoicePriceBill.addMaterials(material)
            }
        }
            
        for other in invoiceDetail.otherItems {
            if other.active {
                pDFInvoicePriceBill.addOthers(other)
            }
        }
      
        return pDFInvoicePriceBill
        
    }
    
    func generateQRCode(invoiceDetails: InvoiceDetails) -> UIImage? {
        //TODO: Check Functionality and Allow it only with valid IBAN on both ends and EUR
        
        guard let qrString = invoiceDetails.getQRCodeDetails else { return nil }
        let data = qrString.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 100, y: 100)
            if let output = filter.outputImage?.transformed(by: transform) {
                let context = CIContext()
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
        
    }
    
    func renderCashReceipt() -> URL {
        
        let pdfContent = contentCashReceipt()
        
        let renderer = ImageRenderer(content: pdfContent)
        
        let url = URL.documentsDirectory.appending(path: "\(invoiceDetails.titleCashReceipt).pdf")
        
        renderer.render { size, context in
            
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
    
        return url
    }
    
    func contentCashReceipt() -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            let localizedCashReceipt = NSLocalizedString("Cash Receipt", comment: "")
            
            Text("\(localizedCashReceipt) \(invoiceDetails.invoiceNumber)")
            
            HStack {
                
                let paymentForInvoiceLoc = NSLocalizedString("Payment for Invoice", comment: "")
                
                PDFInvoiceSummaryBubble(title: NSLocalizedString("Purpose", comment: ""), value: "\(paymentForInvoiceLoc) \(invoiceDetails.invoiceNumber)")
                
                PDFInvoiceSummaryBubble(title: NSLocalizedString("Date of Issue", comment: ""), value: invoiceDetails.dateCreated.formatted(date: .numeric, time: .omitted))
                
                PDFInvoiceSummaryBubble(title: NSLocalizedString("Price total", comment: ""), value: invoiceDetails.totalPrice.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                
            }.padding(.vertical, 15)
            
            HStack {
                
                if let client = invoiceDetails.client {
                    
                    VStack(alignment: .leading) {
                        
                        Text(NSLocalizedString("Customer", comment: ""))
                            .font(.system(size: 13, weight: .bold))
                        
                        PDFClientInfoView(client: client, isVertical: true)
                        
                        Spacer()
                        
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    
                    if let contractor = invoiceDetails.contractor, let name = contractor.name {
                        
                        HStack(spacing: 5) {
                            
                            Text(NSLocalizedString("Made by", comment: ""))
                                .font(.system(size: 15))
                            
                            Spacer()
                            
                            Text(name)
                                .font(.system(size: 15))
                                .frame(width: 125, alignment: .trailing)
                            
                        }
                    }
                    
                    Rectangle().foregroundStyle(Color.brandBlack).frame(maxWidth: .infinity).frame(height: 1)
                    
                    PDFInvoiceTotalPriceView(invoiceDetails)
                    
                    if let imageData = invoiceDetails.contractor?.signature, let signature =  UIImage(data: imageData) {
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text(NSLocalizedString("Issued by:", comment: ""))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.brandBlack)
                            
                            Image(uiImage: signature)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 80)
                                .clipShape(.rect(cornerRadius: 10, style: .continuous))
                        }.padding(.top, 10)
                    }
                    Spacer()
                }.frame(width: 280)
                
            }
            
            Spacer()
            
            if let contractor = invoiceDetails.contractor {
                PDFContractorInfoView(contractor: contractor)
            }
            
            Text(NSLocalizedString("Created using Fido Building Calcul app.", comment: ""))
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
            
        }.padding(.horizontal, 35)
            .padding(.vertical, 35)
            .frame(width: 630)
            .frame(minHeight: 500, alignment: .top)
        
    }
    
}

struct PDFInvoicePriceBill: Identifiable {
    
    let id = UUID()
    var works: [InvoiceItem] = []
    var worksPrice: Double = 0.0
    var materials: [InvoiceItem] = []
    var materialsPrice: Double = 0.0
    var others: [InvoiceItem] = []
    var othersPrice: Double = 0.0
    
    mutating func addWorks(_ newInvoiceItem: InvoiceItem) {
        if newInvoiceItem.price > 0.0 {
            if let indexNum = works.firstIndex(where: { invoiceItem in
                invoiceItem.title == newInvoiceItem.title
            }) {
                if newInvoiceItem.title == AuxiliaryAndFinishingWork.title {
                    works[indexNum].joinInvoiceItem(with: newInvoiceItem)
                    worksPrice += newInvoiceItem.price
                    works.rearrangeToLast(fromIndex: indexNum)
                } else {
                    works[indexNum].joinInvoiceItem(with: newInvoiceItem)
                    worksPrice += newInvoiceItem.price
                }
            } else {
                self.works.append(newInvoiceItem)
                self.worksPrice += newInvoiceItem.price
            }
        }
    }
    
    mutating func addMaterials(_ newInvoiceItem: InvoiceItem) {
        if newInvoiceItem.price > 0.0 {
            if let indexNum = materials.firstIndex(where: { invoiceItem in
                invoiceItem.title == newInvoiceItem.title
            }) {
                
                if newInvoiceItem.title == AuxiliaryAndFasteningMaterial.title {
                    materials[indexNum].joinInvoiceItem(with: newInvoiceItem)
                    materialsPrice += newInvoiceItem.price
                    materials.rearrangeToLast(fromIndex: indexNum)
                } else {
                    materials[indexNum].joinInvoiceItem(with: newInvoiceItem)
                    materialsPrice += newInvoiceItem.price
                }
            } else {
                self.materials.append(newInvoiceItem)
                self.materialsPrice += newInvoiceItem.price
            }
        }
    }
    
    mutating func addOthers(_ newInvoiceItem: InvoiceItem) {
        if newInvoiceItem.price > 0.0 {
            if let indexNum = others.firstIndex(where: { invoiceItem in
                invoiceItem.title == newInvoiceItem.title
            }) {
                others[indexNum].joinInvoiceItem(with: newInvoiceItem)
                othersPrice += newInvoiceItem.price
            } else {
                self.others.append(newInvoiceItem)
                self.othersPrice += newInvoiceItem.price
            }
        }
    }
    
}


struct PDFInvoiceRowView: View {
    
    var title: LocalizedStringKey
    var price: Double
    var pieces: Double
    var percentage: Double
    var unit: UnitsOfMeasurement
    
    var formatter = NumberFormatter()
    
    init(_ invoiceItem: InvoiceItem) {
        self.percentage = invoiceItem.vat
        self.title = invoiceItem.title
        self.price = invoiceItem.price
        self.pieces = invoiceItem.pieces
        self.unit = invoiceItem.unit
        self.formatter.locale = Locale.current
        self.formatter.numberStyle = .currency
    }
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline) {
            
            let localizedString = title.stringKey ?? ""
            
            Text(NSLocalizedString(localizedString, comment: ""))
                .font(.system(size: 12))
            
            Spacer()
            
            var piecess = pieces
            Text("\(piecess.roundAndRemoveZerosFromEnd())  \(NSLocalizedString(UnitsOfMeasurement.readableSymbol(unit).stringKey ?? "", comment: ""))")
                .font(.system(size: 11))
                .frame(width: 60, alignment: .trailing)

            if let formattedPricePerUnit = formatter.string(from: price/pieces as NSNumber) {
                Text(formattedPricePerUnit)
                    .font(.system(size: 11))
                    .frame(width: 70, alignment: .trailing)
            }
            
            Text((percentage/100), format: .percent.precision(.fractionLength(0)))
                .font(.system(size: 11))
                .frame(width: 60, alignment: .trailing)
            
            if let VATPrice = formatter.string(from: price*(percentage/100) as NSNumber) {
                Text(VATPrice)
                    .font(.system(size: 11))
                    .frame(width: 80, alignment: .trailing)
            }
            
            if let formattedPrice = formatter.string(from: price as NSNumber) {
                Text(formattedPrice)
                    .font(.system(size: 11))
                    .frame(width: 80, alignment: .trailing)
            }
            
        }
        
    }
}

struct PDFInvoiceTotalPriceView: View {
    
    var invoiceDetails: InvoiceDetails
    
    var formatter = NumberFormatter()
    
    init(_ invoiceDetails: InvoiceDetails) {
        self.invoiceDetails = invoiceDetails
        self.formatter.locale = Locale.current
        self.formatter.numberStyle = .currency
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            
            if let formattedPrice = formatter.string(from: invoiceDetails.unPriceWithoutVAT as NSNumber) {
                
                HStack(spacing: 5) {
                    
                    Text(NSLocalizedString("without VAT", comment: ""))
                        .font(.system(size: 15))
                    
                    Spacer()
                    
                    Text(formattedPrice)
                        .font(.system(size: 15))
                        .frame(width: 125, alignment: .trailing)
                    
                }
            }
            
            if let formattedPrice = formatter.string(from: invoiceDetails.unCumulativeVat as NSNumber) {
                
                HStack(spacing: 5) {
                    
                    Text(NSLocalizedString("VAT", comment: ""))
                        .font(.system(size: 15))
                    
                    Spacer()
                    
                    Text(formattedPrice)
                        .font(.system(size: 15))
                        .frame(width: 125, alignment: .trailing)
                    
                }
            }
            
            if let formattedPrice = formatter.string(from: invoiceDetails.totalPrice as NSNumber) {
                
                HStack(spacing: 5) {
                    
                    Text(NSLocalizedString("Total price", comment: ""))
                        .font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Text(formattedPrice)
                        .font(.system(size: 17, weight: .semibold))
                        .lineLimit(1)
                        .frame(alignment: .trailing)
                    
                }
                
            }
         
        }.frame(width: 280)
    }
    
}


struct PDFInvoiceSummaryBubble: View {
    
    var title: String
    var value: String
    
    var body: some View {
        
        if !value.isEmpty {
            VStack(alignment: .leading) {
                
                Text(title)
                    .font(.system(size: 9))
                    .foregroundStyle(.brandBlack)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.brandBlack)
                    .lineLimit(1)
                    .fixedSize()
                    .minimumScaleFactor(0.6)
                
            }.padding(.horizontal, 8)
                .frame(height: 50)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background { RoundedRectangle(cornerRadius: 13, style: .continuous).strokeBorder(.brandGray, lineWidth: 1) }
        }
        
    }
    
}
