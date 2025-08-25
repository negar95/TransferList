//
//  UserDefaultKeys.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import Foundation

enum UserDefaultKeys: String {
    case favorites
}
extension UserDefaults {
    @objc dynamic var favorites: [String] {
        get { stringArray(forKey: UserDefaultKeys.favorites.rawValue) ?? [] }
        set { set(newValue, forKey: UserDefaultKeys.favorites.rawValue) }
    }
}
