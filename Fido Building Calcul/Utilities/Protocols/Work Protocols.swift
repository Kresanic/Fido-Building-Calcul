//
//  Work Procotols.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

protocol WorkType {
    
    static var title: LocalizedStringKey { get }
    static var subTitle: LocalizedStringKey { get }
    static var unit: UnitsOfMeasurement { get }
    
}

extension WorkType {
    static var scrollID: String { "\(Self.title.stringKey ?? "NOTHING") + \(Self.subTitle.stringKey ?? "NOTHING")" }
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
