//
//  Date Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 03/04/2024.
//

import Foundation

extension Date {
    var iso8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
