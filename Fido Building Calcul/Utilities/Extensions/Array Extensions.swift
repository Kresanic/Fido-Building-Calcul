//
//  Array Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

extension Array {
    mutating func rearrangeToLast(fromIndex: Int) {
        let element = self.remove(at: fromIndex)
        self.append(element)
    }
}
