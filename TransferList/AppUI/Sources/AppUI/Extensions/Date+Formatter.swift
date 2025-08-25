//
//  Date+Formatter.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import Foundation

extension Date {
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
