//
//  PDFParts.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

struct PDFTotalPriceView: View {
    
    var priceWithoutVat: Double
    var percentage: Double
    
    var formatter = NumberFormatter()
    
    init(priceWithoutVat: Double, percentage: Double) {
        self.priceWithoutVat = priceWithoutVat
        self.percentage = percentage
        self.formatter.locale = Locale.current
        self.formatter.numberStyle = .currency
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            
           if let formattedPrice = formatter.string(from: priceWithoutVat as NSNumber) {
                
                HStack(spacing: 5) {
                    
                    Spacer()
                    
                    Text(NSLocalizedString("without VAT", comment: ""))
                        .font(.system(size: 15))
                    
                    Text(formattedPrice)
                        .font(.system(size: 15))
                        .frame(width: 125, alignment: .trailing)
                    
                }
            }
            
            if let formattedPrice = formatter.string(from: priceWithoutVat*(percentage/100) as NSNumber) {
                
                HStack(spacing: 5) {
                    
                    Spacer()
                    
                    Text(NSLocalizedString("VAT", comment: ""))
                        .font(.system(size: 15))
                    
                    Text(formattedPrice)
                        .font(.system(size: 15))
                        .frame(width: 125, alignment: .trailing)
                    
                }
            }
            
            if let formattedPrice = formatter.string(from: priceWithoutVat*(percentage/100 + 1) as NSNumber) {
                
                HStack(spacing: 5) {
                    
                    Spacer()
                    
                    Text(NSLocalizedString("Total price", comment: ""))
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(formattedPrice)
                        .font(.system(size: 18, weight: .bold))
                        .lineLimit(1)
                        .frame(alignment: .trailing)
                    
                }
                
            }
         
        }
    }
    
}

struct PDFClientInfoView: View {
    
    var client: Client
    var isVertical: Bool = false
    
    var body: some View {
        
        if isVertical {
            VStack(alignment: .leading, spacing: 15) {
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    PDFPersonalInfoView(value: client.name)
                    
                    PDFPersonalInfoView(value: client.street)
                    
                    PDFPersonalInfoView(value: client.secondRowStreet)
                    
                    PDFPersonalInfoView(value: client.postalCode, secondValue: client.city)
                    
                    PDFPersonalInfoView(value: client.country)
                    
                    PDFPersonalInfoView(value: client.email)
                    
                    PDFPersonalInfoView(value: client.phone)
                    
                }
                
                if client.type == ClientType.corporation.rawValue {
                    VStack(alignment: .leading, spacing: 2) {
                        PDFPersonalInfoView(title: NSLocalizedString("BID", comment: ""), value: client.businessID)
                        
                        PDFPersonalInfoView(title: NSLocalizedString("TID", comment: ""), value: client.taxID)
                        
                        PDFPersonalInfoView(title: NSLocalizedString("VAT ID", comment: ""), value: client.vatRegistrationNumber)
                    }
                }
                
            }
        } else {
            HStack(alignment: .lastTextBaseline, spacing: 30) {
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    PDFPersonalInfoView(value: client.name)
                    
                    PDFPersonalInfoView(value: client.street)
                    
                    PDFPersonalInfoView(value: client.secondRowStreet)
                    
                    PDFPersonalInfoView(value: client.postalCode, secondValue: client.city)
                    
                    PDFPersonalInfoView(value: client.country)
                    
                    PDFPersonalInfoView(value: client.email)
                    
                    PDFPersonalInfoView(value: client.phone)
                    
                }
                
                if client.type == ClientType.corporation.rawValue {
                    VStack(alignment: .leading, spacing: 2) {
                        PDFPersonalInfoView(title: NSLocalizedString("BID", comment: ""), value: client.businessID)
                        
                        PDFPersonalInfoView(title: NSLocalizedString("TID", comment: ""), value: client.taxID)
                        
                        PDFPersonalInfoView(title: NSLocalizedString("VAT ID", comment: ""), value: client.vatRegistrationNumber)
                    }
                }
                
            }
        }
        
    }
}

struct PDFContractorSubInfoView: View {
    
    var contractor: Client
    
    var body: some View {
        
        HStack(alignment: .lastTextBaseline, spacing: 30) {
            
            VStack(alignment: .leading, spacing: 2) {
                
                PDFPersonalInfoView(value: contractor.name)
                
                PDFPersonalInfoView(value: contractor.street)
                
                PDFPersonalInfoView(value: contractor.secondRowStreet)
                
                PDFPersonalInfoView(value: contractor.postalCode, secondValue: contractor.city)
                
                PDFPersonalInfoView(value: contractor.country)
                
            }
            
            
            VStack(alignment: .leading, spacing: 2) {
                PDFPersonalInfoView(title: NSLocalizedString("BID", comment: ""), value: "2139841")
                
                PDFPersonalInfoView(title: NSLocalizedString("TID", comment: ""), value: "2139841")
                
                PDFPersonalInfoView(title: NSLocalizedString("VAT ID", comment: ""), value: "2139841")
                
                PDFPersonalInfoView(title: NSLocalizedString("Legal appendix", comment: ""), value: "Okr. súd [PO], odd. SRO, vl. č [1234567]")
            }
            
            VStack(alignment: .leading, spacing: 2) {
                
                PDFPersonalInfoView(title: NSLocalizedString("Bank account number", comment: ""), value: "SK8975000000000012345671")
                
                PDFPersonalInfoView(title: NSLocalizedString("Bank Code", comment: ""), value: "TATRSKBX")
                
            }
            
        }
        
    }
}


struct PDFContractorInfoView: View {
    
    var contractor: Contractor
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                if let contactName = contractor.contactPersonName {
                    PDFPersonalInfoView(icon: "person.fill", value: contactName)
                    
                    Spacer()
                }
                if let phone = contractor.phone {
                    PDFPersonalInfoView(icon: "phone.fill", value: phone)
                    
                    Spacer()
                }
                
                if let web = contractor.web {
                    PDFPersonalInfoView(icon: "globe", value: web)
                    
                    Spacer()
                }
                
                if let email = contractor.email {
                    
                    PDFPersonalInfoView(icon: "envelope.fill", value: email)
                    
                }
                
            }
            
            Rectangle().foregroundStyle(Color.brandBlack).frame(maxWidth: .infinity).frame(height: 1)
            
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    PDFPersonalInfoView(value: contractor.name)
                    
                    PDFPersonalInfoView(value: contractor.street)
                    
                    PDFPersonalInfoView(value: contractor.secondRowStreet)
                    
                    PDFPersonalInfoView(value: contractor.postalCode, secondValue: contractor.city)
                    
                    PDFPersonalInfoView(value: contractor.country)
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    PDFPersonalInfoView(title: NSLocalizedString("BID", comment: ""), value: contractor.businessID)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("TID", comment: ""), value: contractor.taxID)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("VAT ID", comment: ""), value: contractor.vatRegistrationNumber)
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Legal appendix", comment: ""), value: contractor.legalNotice)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Bank account number", comment: ""), value: contractor.bankAccountNumber)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Bank Code", comment: ""), value: contractor.swiftCode)
                    
                }
                
            }
            
        }
        
    }
    
}

struct PDFPersonalInfoView: View {
    
    var title: String?
    var icon: String?
    var value: String?
    var secondValue: String?
    var spaced = false
    
    var body: some View {
        if let value {
            if !value.isEmpty {
                HStack(spacing: 0) {
                    
                    if let title {
                        Text("\(title): ")
                            .font(.system(size: 10))
                            .fixedSize()
                            .frame(minWidth: 50, alignment: .leading)
                    } else if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 10))
                            .fixedSize(horizontal: true, vertical: true)
                            .padding(.trailing, 4)
                    }
                    
                    if spaced { Spacer() }
                    
                    if let secondValue {
                        if !secondValue.isEmpty {
                            Text("\(value) \(secondValue)")
                                .font(.system(size: 10))
                                .fixedSize()
                        }
                    } else {
                        Text(value)
                            .font(.system(size: 10))
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
            }
        }
        
    }
    
}

struct PDFRowView: View {
    
    var priceBillRow: PriceBillRow
    var percentage: Double
    var formatter = NumberFormatter()
    
    init(priceBillRow: PriceBillRow, percentage: Double) {
        self.percentage = percentage
        self.priceBillRow = priceBillRow
        self.formatter.locale = Locale.current
        self.formatter.numberStyle = .currency
    }
    
    var body: some View {
        
        HStack {
            
            let localizedString = priceBillRow.name.stringKey ?? ""
            
            Text(NSLocalizedString(localizedString, comment: ""))
                .font(.system(size: 12))
            
            Spacer()
            
            var pieces = priceBillRow.pieces
            
            Text("\(pieces.roundAndRemoveZerosFromEnd()) \(NSLocalizedString(UnitsOfMeasurement.readableSymbol(priceBillRow.unit).stringKey ?? "", comment: ""))")
                .font(.system(size: 12))
                .frame(width: 60, alignment: .trailing)

            if let formattedPricePerUnit = formatter.string(from: priceBillRow.price/priceBillRow.pieces as NSNumber) {
                Text(formattedPricePerUnit)
                    .font(.system(size: 12))
                    .frame(width: 70, alignment: .trailing)
            }
            
            Text((percentage/100), format: .percent.precision(.fractionLength(0)))
                .font(.system(size: 12))
                .frame(width: 60, alignment: .trailing)
            
            if let VATPrice = formatter.string(from: priceBillRow.price*(percentage/100) as NSNumber) {
                Text(VATPrice)
                    .font(.system(size: 12))
                    .frame(width: 80, alignment: .trailing)
            }
            
            if let formattedPrice = formatter.string(from: priceBillRow.price as NSNumber) {
                Text(formattedPrice)
                    .font(.system(size: 12))
                    .frame(width: 80, alignment: .trailing)
            }
            
        }
        
    }
}
