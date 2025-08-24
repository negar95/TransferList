//
//  Loadable.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/23/25.
//


import Foundation

public enum Loadable<T: Equatable>: Equatable {
    case error(String)
    case loaded(T)
    case isLoading(refreshing: Bool = false)
    case notRequested

    public var value: T? {
        guard case let .loaded(t) = self else { return nil }
        return t
    }
}
