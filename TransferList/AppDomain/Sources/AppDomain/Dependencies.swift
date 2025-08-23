//
//  Dependencies.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import AppFoundation
import Foundation

final class Dependencies: @unchecked Sendable {
    static let shared = Dependencies()
    private init() {}

    private let lock = NSLock()
    private var _networkManager: NetworkManagerProtocol?
    private var _jsonDecoder: JSONDecoder?
    private var _urlSession: URLSession?

    var networkManagerFactory: () -> NetworkManagerProtocol {
        return { [weak self] in
            guard let self else { return NetworkManager() }
            return lock.withLock {
                if let existingValue = _networkManager { return existingValue }
                let newValue = NetworkManager()
                _networkManager = newValue
                return newValue
            }
        }
    }
    var jsonDecoderFactory: () -> JSONDecoder {
        return { [weak self] in
            guard let self else { return JSONDecoder() }
            return lock.withLock {
                if let existing = _jsonDecoder { return existing }
                let newValue = JSONDecoder()
                newValue.dateDecodingStrategy = .iso8601
                _jsonDecoder = newValue
                return newValue
            }
        }
    }
    var urlSessionFactory: () -> URLSession {
        return { [weak self] in
            guard let self else { return URLSession(configuration: .default) }
            return lock.withLock {
                if let existingValue = _urlSession { return existingValue }
                let newValue = URLSession(configuration: .default)
                _urlSession = newValue
                return newValue
            }
        }
    }
}
