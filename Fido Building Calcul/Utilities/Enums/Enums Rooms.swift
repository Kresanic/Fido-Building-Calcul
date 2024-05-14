//
//  Enums Rooms.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

enum NumberOfInputs { case one, two }

enum FocusedDimension { case first, second }

enum TripleFocusedDimension {
    case first, second, third
    
    var advance: Self? {
        switch self {
        case .first:
            .second
        case .second:
            .third
        case .third:
            nil
        }
    }
    
}

enum DimensionCallout: String {
    
    case durationOfWork, numberOfOutlets, height, width, length, windowLining, count, price, circumference, commuteLength, rentalLength
    
    static func readableSymbol(_ self: Self) -> LocalizedStringKey {
        switch self {
        case .durationOfWork:
            "Duration"
        case .numberOfOutlets:
            "Number of outlets"
        case .height:
            "Height"
        case .width:
            "Width"
        case .length:
            "Length"
        case .windowLining:
            "Window lining"
        case .count:
            "Count"
        case .price:
            "Price"
        case .circumference:
            "Circumference"
        case .commuteLength:
            "Commute length"
        case .rentalLength:
            "Rental duration"
        }
        
    }
    
}

enum RoomTypes: String, CaseIterable {
    
    case hallway, toilet, bathroom, kitchen, livingroom, kidsroom, bedroom, geustsroom, workroom, other
    
    static func rawValueToString(_ t: String) -> String {
        switch t {
        case "hallway":
            return String(localized: "Hallway")
        case "toilet":
            return String(localized: "Toilet")
        case "bathroom":
            return String(localized: "Bathroom")
        case "kitchen":
            return String(localized: "Kitchen")
        case "livingroom":
            return String(localized: "Living room")
        case "kidsroom":
            return String(localized: "Kids room")
        case "bedroom":
            return String(localized: "Bedroom")
        case "geustsroom":
            return String(localized: "Guests room")
        case "workroom":
            return String(localized: "Work room")
        case "other":
            return String(localized: "Custom")
        default:
            return t
        }
    }
    
    static func readable(_ t: RoomTypes) -> LocalizedStringKey {
        switch t {
        case .hallway:
            return "Hallway"
        case .toilet:
            return "Toilet"
        case .bathroom:
            return "Bathroom"
        case .kitchen:
            return "Kitchen"
        case .livingroom:
            return "Living room"
        case .kidsroom:
            return "Kids room"
        case .bedroom:
            return "Bedroom"
        case .geustsroom:
            return "Guests room"
        case .workroom:
            return "Work room"
        case .other:
            return "Custom"
        }
    }
    
    static func parseToReadable(_ s: String?) -> LocalizedStringKey {
        switch s {
        case "Hallway":
            return "Hallway"
        case "Toilet":
            return "Toilet"
        case "Bathroom":
            return "Bathroom"
        case "Kitchen":
            return "Kitchen"
        case "Living room":
            return "Living room"
        case "Kids room":
            return "Kids room"
        case "Bedroom":
            return "Bed room"
        case "Guests room":
            return "Guests room"
        case "Work room":
            return "Work room"
        case "Custom":
            return "Custom"
        default:
            return LocalizedStringKey(stringLiteral: s ?? "No name")
        }
    }
    
}
