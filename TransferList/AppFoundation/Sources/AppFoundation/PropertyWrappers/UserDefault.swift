//
//  UserDefault.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    let storage: UserDefaults
    
    public init(
        _ key: String,
        default defaultValue: Value,
        storage: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    public var wrappedValue: Value {
        get {
            if let data = storage.data(forKey: key) {
                if let value = try? JSONDecoder().decode(Value.self, from: data) {
                    return value
                }
            }
            return defaultValue
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                storage.set(data, forKey: key)
            } else {
                storage.removeObject(forKey: key)
            }
        }
    }
}
