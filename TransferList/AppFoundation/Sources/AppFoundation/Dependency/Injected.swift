//
//  DependencyContainer.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

@propertyWrapper
public final class Injected<T> {
    private let factory: () -> T
    private var cached: T?

    public var wrappedValue: T {
        if let cached = cached {
            return cached
        }
        let instance = factory()
        cached = instance
        return instance
    }

    public init(_ factory: @escaping () -> T) {
        self.factory = factory
    }
}
