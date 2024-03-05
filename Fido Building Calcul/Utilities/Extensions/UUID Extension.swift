//
//  UUID Extension.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 05/03/2024.
//

import Foundation

extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
