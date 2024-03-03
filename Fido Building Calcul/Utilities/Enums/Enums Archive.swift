//
//  Enums Archive.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import Foundation

enum ArchiveForTime: Int, CaseIterable {
    case twoWeeks = 14
    case month = 30
    case twoMonths = 60
    case forever = 99999
}

enum ValidityDurations: Int, CaseIterable {
    case week = 7
    case biWeek = 14
    case month = 30
    case twoMonths = 60
}
