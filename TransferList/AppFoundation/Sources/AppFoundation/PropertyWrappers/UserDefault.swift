//
//  UserDefault.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import Foundation
import Combine

@propertyWrapper
public struct UserDefault<Value: Equatable & Codable> {
    private let keyPath: ReferenceWritableKeyPath<UserDefaults, Value>
    private let storage: UserDefaults

    public init(
        _ keyPath: ReferenceWritableKeyPath<UserDefaults, Value>,
        storage: UserDefaults = .standard
    ) {
        self.keyPath = keyPath
        self.storage = storage
    }
    public var wrappedValue: Value {
        get { storage[keyPath: keyPath] }
        set { storage[keyPath: keyPath] = newValue }
    }
    public var projectedValue: AnyPublisher<Value, Never> {
        storage
            .publisher(for: keyPath)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
