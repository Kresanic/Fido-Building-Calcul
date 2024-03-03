//
//  Binding Extensions.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//

import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
