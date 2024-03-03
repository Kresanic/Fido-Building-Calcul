//
//  Protocols.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 05/10/2023.
//

import SwiftUI
import CoreData

enum UnitsOfMeasurment: String {
    
    case basicMeter, meter, squareMeter, cubicMeter, piece, package, hour, kilometer, percentage, day
    
    static func readableSymbol(_ self: Self) -> String {
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
            return "ks"
        case .package:
            return "bal."
        case .hour:
            return "hod."
        case .kilometer:
            return "km"
        case .percentage:
            return "%"
        case .day:
            return "dní"
        }
        
    }
    
    static func parse(_ s: String?) -> UnitsOfMeasurment {
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
        default:
            return .basicMeter
        }
    }
}

protocol WorkType {
    
    var title: String { get }
    var subTitle: String { get }
    var unit: UnitsOfMeasurment { get }
    
}

protocol CountBasedWorkType: WorkType {
    
    var count: Double { get }
    
}

protocol AreaBasedWorkType: WorkType {
    
    var size1: Double { get }
    var size2: Double { get }
    
}

extension AreaBasedWorkType {
    
    var area: Double { size1 * size2 }
    
}
