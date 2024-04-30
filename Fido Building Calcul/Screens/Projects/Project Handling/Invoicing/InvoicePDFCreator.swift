//
//  InvoicePDFCreator.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/04/2024.
//

import SwiftUI
import PDFKit
import CoreData

final class InvoicePDFCreator {
    

    
    func generateQRCode(invoiceDetails: InvoiceDetails) -> UIImage? {
        //TODO: Check Functionality and Allow it only with valid IBAN on both ends and EUR
        
        guard let qrString = invoiceDetails.getQRCodeDetails else { return nil }
        
        let data = qrString.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10) // Scale up to improve quality

            if let output = filter.outputImage?.transformed(by: transform) {
                let context = CIContext()
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
        
    }
    
    func isValidIBAN(_ iban: String) -> Bool {
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
