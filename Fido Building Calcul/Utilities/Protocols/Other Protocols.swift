//
//  Other Protocols.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

protocol OtherType {
    
    static var title: LocalizedStringKey { get }
    static var subTitle: LocalizedStringKey { get }
    static var unit: UnitsOfMeasurement { get }
    
}

extension OtherType {
    
    static var scrollID: String { "\(Self.title.stringKey ?? "NOTHING") + \(Self.subTitle.stringKey ?? "NOTHING")" }
    
}

protocol CountBasedOtherType: OtherType {
    
    var count: Double { get }
    
}

protocol AreaBasedOtherType: OtherType {
    
    var size1: Double { get }
    var size2: Double { get }
    
}

extension AreaBasedOtherType {
    
    var area: Double { size1 * size2 }
    
}
