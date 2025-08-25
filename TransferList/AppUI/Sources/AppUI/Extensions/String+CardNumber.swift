//
//  String+CardNumber.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/25/25.
//

extension String {
    public var formattedCardNumber: String {
        guard count > 5 else { return self }
        return prefix(2) + " *** " + suffix(3)
    }
}
