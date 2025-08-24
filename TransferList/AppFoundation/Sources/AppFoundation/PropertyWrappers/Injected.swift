//
//  DependencyContainer.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

@propertyWrapper
public final class Injected<T>: @unchecked Sendable where T: Sendable {
    private let factory: () -> T
    private var cached: T?
    private let lock = NSLock()

    public var wrappedValue: T {
        lock.lock()
        defer { lock.unlock() }

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
