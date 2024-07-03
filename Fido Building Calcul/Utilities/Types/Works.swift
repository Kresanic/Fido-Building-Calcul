//
//  Works.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

public class AuxiliaryAndFinishingWork: WorkType {
    
    var dateCreated: Date?
    
    static var title: LocalizedStringKey = "Auxiliary and finishing work"
    
    static var subTitle: LocalizedStringKey = ""
    
    static var unit: UnitsOfMeasurement = .percentage
    
}

public class LargeFormatPavingAndTiling: WorkType {
    
    var dateCreated: Date?
    
    static var title: LocalizedStringKey = "Large Format"
    
    static var subTitle: LocalizedStringKey = "above 60cm"
    
    static var pavingBillTitle: LocalizedStringKey = "Paving, large format"
    
    static var tilingBillTitle: LocalizedStringKey = "Tiling, large format"
    
    static var unit: UnitsOfMeasurement = .squareMeter
    
}


public class JollyEdging: WorkType {
    
    static var title: LocalizedStringKey = "Jolly Edging"
    
    static var subTitle: LocalizedStringKey = ""
    
    static var unit: UnitsOfMeasurement = .meter
    
}

public class PlinthCutting: WorkType {
    
    static var title: LocalizedStringKey = "Plinth"
    
    static var subTitle: LocalizedStringKey = "cutting and grinding"
    
    static var billTitle: LocalizedStringKey = "Plinth, cutting/grinding"
    
    static var unit: UnitsOfMeasurement = .meter
    
}

public class PlinthBonding: WorkType {
    
    static var title: LocalizedStringKey = "Plinth"
    
    static var subTitle: LocalizedStringKey = "bonding"
    
    static var billTitle: LocalizedStringKey = "Plinth, bonding"
    
    static var unit: UnitsOfMeasurement = .meter
    
}
