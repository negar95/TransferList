//
//  Array+ SafeSubscript.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/21/25.
//

public extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
