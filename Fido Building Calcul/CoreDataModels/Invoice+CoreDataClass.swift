//
//  Invoice+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Invoice)
public class Invoice: NSManagedObject {
    
    var stringNumber: String {
        String(number)
    }
    
//    func testStatus() {
//        
//        guard let currentStatus = InvoiceStatus(rawValue: status ?? "") else { return }
//        
//        print("\n===========================")
//        
//        print("Invoice num:", number)
//        
//        print("Date created:", dateCreated)
//        
//        print("Current status:", currentStatus)
//        
//        print("Maturity cutoff date:", maturityCutOffDate)
//        
//        print("Maturity days balance:", maturityStatus)
//        
//        print("Days for maturity:", maturityDays)
//        
//        print("=========================== \n")
//        
////        if Date.now.startOfTheDay > maturityCutOffDate && currentStatus == .unpaid { print("After maturity") } else { print("Not After Maturity") }
//        
//    }
    
    var maturityCutOffDate: Date {
        return Calendar.current.date(byAdding: .day, value: Int(maturityDays), to: dateCreated ?? Date.now) ?? Date.now
    }
    
//    var invoiceFiltering: InvoiceStatus? {
//        
//        guard let currentCase = InvoiceStatus(rawValue: status ?? "") else { return nil }
//        
//        if currentCase == .paid { return .paid }
//        
//        let isAfterMaturity = Date.now.startOfTheDay > maturityCutOffDate
//        
//        print("======================")
//        
//        print("number", number)
//        
//        print("Date.now.startOfTheDay > maturityCutOffDate", Date.now.startOfTheDay > maturityCutOffDate, "if true then afterMaturity")
//        
//        print("currentCase == .unpaid", currentCase == .unpaid)
//        
//        print("======================")
//        
//        if isAfterMaturity { return .afterMaturity }
//    
//        return .unpaid
//        
//    }

    var statusCase: InvoiceStatus {
        
        let currentCase = InvoiceStatus(rawValue: status ?? "unpaid") ?? .unpaid
        
        if Date.now.startOfTheDay > maturityCutOffDate && currentCase == .unpaid { return .afterMaturity } else { return currentCase }
        
    }
    
    var bubble: some View {
        
        let statusCase = self.statusCase
        let statusCaseNameLoc = NSLocalizedString(statusCase.name.stringKey ?? "unpaid", comment: "").capitalized
        
        if statusCase == .unpaid, let maturityStatus {
            return Text("\(statusCaseNameLoc), in \(maturityStatus) days")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.brandWhite)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(statusCase.backgroundColor)
                    .fixedSize()
                    .clipShape(.capsule)
       } else if statusCase == .afterMaturity, let maturityStatus {
           return Text("\(statusCaseNameLoc) \(maturityStatus) days ago")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.brandWhite)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(statusCase.backgroundColor)
                    .fixedSize()
                    .clipShape(.capsule)
        } else {
            return Text("\(statusCaseNameLoc)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.brandWhite)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(statusCase.backgroundColor)
                    .fixedSize()
                    .clipShape(.capsule)
        }
        
        
        
    }
    
    var maturityStatus: Int? {
        
        guard let status = self.status else { return nil }
        guard let currentCase = InvoiceStatus(rawValue: status) else { return nil }
        
        if currentCase != .paid {
            return abs(Int(Date.now.distance(to: maturityCutOffDate)/60/60/24))
        }
        
        return nil
        
    }
    
    
//    var daysOfMaturity: Int? {
//        
//        let maturityCutOff = Calendar.current.date(byAdding: .day, value: Int(maturityDays), to: dateCreated ?? Date.now) ?? Date.now
//        
//        guard let dateCreated else { return nil }
//        
//        return Int(dateCreated.distance(to: maturityCutOff)/60/60/24)
//        
//    }
//    
//    var statusCase: InvoiceStatus? {
//        
//        guard let currentCase = InvoiceStatus(rawValue: status ?? "") else { return nil }
//        
//        guard let daysTillMaturity = daysOfMaturity else { return nil }
//        
//        if currentCase == .unpaid && daysTillMaturity <= 0 {
//            return .afterMaturity
//        } else {
//            return currentCase
//        }
//        
//    }
//    
//    var bubble: some View {
//        
//        guard let statusCase = self.statusCase, let daysOfMaturity else {
//                  return Text("")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundStyle(.clear)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 2)
//                            .background(.clear)
//                            .fixedSize()
//                            .clipShape(.capsule)
//            
//              }
//              
//        let statusCaseNameLoc = NSLocalizedString(statusCase.name.stringKey ?? "unpaid", comment: "").capitalized
//        
//        if statusCase == .unpaid {
//            return Text("\(statusCaseNameLoc), in \(daysOfMaturity) days")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundStyle(.brandWhite)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 2)
//                    .background(statusCase.backgroundColor)
//                    .fixedSize()
//                    .clipShape(.capsule)
//       } else if statusCase == .afterMaturity {
//           return Text("\(statusCaseNameLoc), \(daysOfMaturity) days ago")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundStyle(.brandWhite)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 2)
//                    .background(statusCase.backgroundColor)
//                    .fixedSize()
//                    .clipShape(.capsule)
//       } else if statusCase == .paid {
//            return Text("\(statusCaseNameLoc)")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundStyle(.brandWhite)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 2)
//                    .background(statusCase.backgroundColor)
//                    .fixedSize()
//                    .clipShape(.capsule)
//       } else {
//           return Text("")
//               .font(.system(size: 14, weight: .semibold))
//               .foregroundStyle(.clear)
//               .padding(.horizontal, 8)
//               .padding(.vertical, 2)
//               .background(.clear)
//               .fixedSize()
//               .clipShape(.capsule)
//       }
//
//    }
    
    
}
