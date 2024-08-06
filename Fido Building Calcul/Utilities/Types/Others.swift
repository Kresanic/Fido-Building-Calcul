//
//  Others.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

//public class ToolRental: OtherType {
//    
//    static var title: LocalizedStringKey = "Tool rental"
//    static var subTitle: LocalizedStringKey = ""
//    static var unit: UnitsOfMeasurement = .hour
//    static var scrollID: String = "\(title) + \(subTitle)"
//    
//}

public class Commute: OtherType {
    
    static var title: LocalizedStringKey = "Commute"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .kilometer
    static var scrollID: String = "\(title) + \(subTitle)"
    
}

public class VAT: OtherType {
    
    static var title: LocalizedStringKey = "VAT"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurement = .percentage
    
}

