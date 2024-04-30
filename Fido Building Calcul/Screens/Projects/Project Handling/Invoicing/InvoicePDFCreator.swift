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
    
    let invoiceDetails: InvoiceDetails
    let invoiceItems: [InvoiceItem]
    
    init(_ invoiceDetails: InvoiceDetails,_ invoiceItems: [InvoiceItem]) {
        self.invoiceDetails = invoiceDetails
        self.invoiceItems = invoiceItems
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
                    
                    Text(invoiceDetails.invoiceNumber)
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
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
//                    
//                    Spacer()
//                    
//                    PDFPersonalInfoView(title: NSLocalizedString("Date of issue", comment: ""), value: Date.now.formatted(date: .numeric, time: .omitted), spaced: true)
//                    
//                    PDFPersonalInfoView(title: NSLocalizedString("Valid until", comment: ""), value: Date.now.addingTimeInterval(TimeInterval(priceOfferValidity*24*60*60)).formatted(date: .numeric, time: .omitted), spaced: true)
                    
                }.frame(width: 175)
                
            }.frame(maxHeight: 170)
            
//            if let projectSumUp = projectSumUp(project) {
//                
//                HStack {
//                    
//                    Text(NSLocalizedString("Description", comment: ""))
//                        .font(.system(size: 12, weight: .medium))
//                    
//                    Spacer()
//                    
//                    Text(NSLocalizedString("Count", comment: ""))
//                        .font(.system(size: 12, weight: .medium))
//                        .frame(width: 60, alignment: .trailing)
//                    
//                    Text(NSLocalizedString("Price per unit", comment: ""))
//                        .font(.system(size: 12, weight: .medium))
//                        .frame(width: 75, alignment: .trailing)
//                    
//                    Text(NSLocalizedString("VAT(%)", comment: ""))
//                        .font(.system(size: 12, weight: .medium))
//                        .frame(width: 60, alignment: .trailing)
//                    
//                    Text(NSLocalizedString("VAT", comment: ""))
//                        .font(.system(size: 12, weight: .medium))
//                        .frame(width: 60, alignment: .trailing)
//                    
//                    Text(NSLocalizedString("Price", comment: ""))
//                        .font(.system(size: 12, weight: .medium))
//                        .frame(width: 80, alignment: .trailing)
//                    
//                }.padding(.top, 20)
//                
//                Rectangle()
//                    .foregroundStyle(Color.brandBlack)
//                    .frame(maxWidth: .infinity, maxHeight: 1).padding(.vertical, 4)
//                
//                if !projectSumUp.works.isEmpty {
//                    Text(NSLocalizedString("Work", comment: ""))
//                        .font(.system(size: 10, weight: .medium))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.bottom, 2)
//                }
//                
//                ForEach(projectSumUp.works) { work in
//                    
//                    PDFRowView(priceBillRow: work, percentage: projectSumUp.VATPercentage)
//                    
//                }
//                
//                if !projectSumUp.materials.isEmpty {
//                    Text(NSLocalizedString("Material", comment: ""))
//                        .font(.system(size: 10, weight: .medium))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top, 3)
//                        .padding(.bottom, 2)
//                }
//                
//                ForEach(projectSumUp.materials) { material in
//                    
//                    PDFRowView(priceBillRow: material, percentage: projectSumUp.VATPercentage)
//                    
//                }
//                
//                if !projectSumUp.others.isEmpty {
//                    Text(NSLocalizedString("Others", comment: ""))
//                        .font(.system(size: 10, weight: .medium))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top, 3)
//                        .padding(.bottom, 2)
//                }
//                
//                ForEach(projectSumUp.others) { other in
//                    
//                    PDFRowView(priceBillRow: other, percentage: projectSumUp.VATPercentage)
//                    
//                }
//                
//                Rectangle()
//                    .foregroundStyle(Color.brandBlack)
//                    .frame(maxWidth: .infinity, maxHeight: 1).padding(.vertical, 4)
//                
//                PDFTotalPriceView(priceWithoutVat: projectSumUp.priceWithoutVat, percentage: projectSumUp.VATPercentage)
//                
//            } else { Text(NSLocalizedString("PDF could not be created.", comment: "")) }
            
            if let qrCode = generateQRCode(invoiceDetails: invoiceDetails) {
                Image(uiImage: qrCode)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            Text(invoiceDetails.price ?? 69.42, format: .number)
                .font(.largeTitle)
            
            Spacer()
            
            if let contractor = invoiceDetails.contractor {
                PDFContractorInfoView(contractor: contractor)
            }
            
            
            
//            Text(NSLocalizedString("Created using Fido Building Calcul app.", comment: ""))
//                .font(.system(size: 10))
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.top, 15)
            
        }.padding(.horizontal, 35)
            .padding(.vertical, 35)
            .frame(width: 630)
            .frame(minHeight: 891)
        
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
    
    func isValidIBAN(_ iban: String?) -> Bool {
        //TODO: CHECK FUNCTIONALITY
        guard let iban else { return false }
        // Remove any whitespace and convert to uppercase
        let formattedIBAN = iban.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Check if the IBAN has the correct length
        guard formattedIBAN.count >= 15 && formattedIBAN.count <= 34 else {
            return false
        }
        
        // Check if the IBAN begins with a valid country code (2 letters)
        let countryCodePattern = "[A-Z]{2}"
        guard let countryCodeRegex = try? NSRegularExpression(pattern: countryCodePattern),
              let countryCodeMatch = countryCodeRegex.firstMatch(in: formattedIBAN, range: NSRange(location: 0, length: 2)),
              countryCodeMatch.range.location == 0 else {
            return false
        }
        
        // Move the country code to the end of the IBAN and replace letters with numbers
        var modifiedIBAN = formattedIBAN
        let countryCode = String(formattedIBAN.prefix(2))
        modifiedIBAN.removeFirst(2)
        modifiedIBAN += countryCode
        
        modifiedIBAN = modifiedIBAN.replacingOccurrences(of: "A", with: "10")
        modifiedIBAN = modifiedIBAN.replacingOccurrences(of: "B", with: "11")
        modifiedIBAN = modifiedIBAN.replacingOccurrences(of: "C", with: "12")
        // Continue replacing letters with their corresponding numbers (C = 12, D = 13, ..., Z = 35)
        
        // Convert the modified IBAN string to an integer
        guard let ibanNumber = Int(modifiedIBAN) else {
            return false
        }
        
        // Check if the remainder of the division by 97 is equal to 1
        return ibanNumber % 97 == 1
    }
    
}
