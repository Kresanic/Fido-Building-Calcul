//
//  Material Protocols.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

protocol MaterialType {
    
    static var title: LocalizedStringKey { get }
    static var subTitle: LocalizedStringKey { get }
    static var unit: UnitsOfMeasurment { get }
    static var capacityUnity: UnitsOfMeasurment? { get }
    
}
