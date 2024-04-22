//
//  Enums Roots.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 27/11/2023.
//

import SwiftUI

enum CustomTabs { case projects, clients, settings, invoices }

enum DialogAlertType { case approval, warning }

public enum UnitsOfMeasurement: String {
    
    case basicMeter, meter, squareMeter, cubicMeter, piece, package, hour, kilometer, percentage, day, kilogram, ton
    
    static func readableSymbol(_ self: Self) -> LocalizedStringKey {
        switch self {
        case .basicMeter:
            return "bm"
        case .meter:
            return "m"
        case .squareMeter:
            return "m\u{00B2}"
        case .cubicMeter:
            return "m\u{00B3}"
        case .piece:
            return "pc"
        case .package:
            return "pkg"
        case .hour:
            return "h"
        case .kilometer:
            return "km"
        case .percentage:
            return "%"
        case .day:
            return "day"
        case .kilogram:
            return "kg"
        case .ton:
            return "t"
        }
        
    }
    
    static func parse(_ s: String?) -> UnitsOfMeasurement {
        switch s {
        case "basicMeter":
            return .basicMeter
        case "meter":
            return .meter
        case "squareMeter":
            return .squareMeter
        case "cubicMeter":
            return .cubicMeter
        case "piece":
            return .piece
        case "package":
            return .package
        case "hour":
            return .hour
        case "kilometer":
            return .kilometer
        case "percentage":
            return .percentage
        case "day":
            return .day
        case "kilogram":
            return .kilogram
        case "ton":
            return .ton
        default:
            return .basicMeter
        }
    }
    
}
