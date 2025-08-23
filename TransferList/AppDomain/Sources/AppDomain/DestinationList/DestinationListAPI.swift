//
//  DestinationListAPI.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation
import AppFoundation

public protocol DestinationListAPIProtocol {
    func list(page: UInt) async throws -> [DestinationResponse]
}

public final class DestinationListAPI: DestinationListAPIProtocol {

    @Injected(Dependencies.shared.networkManagerFactory) private var networkManager: NetworkManagerProtocol
    @Injected(Dependencies.shared.jsonDecoderFactory) private var jsonDecoder: JSONDecoder

    public init() {}
    public func list(page: UInt) async throws -> [DestinationResponse] {
        let (data, _) = try await networkManager.request(DestinationListRequest.list(page: page))
        return try jsonDecoder.decode([DestinationResponse].self, from: data)
    }
}
