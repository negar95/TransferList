//
//  NetworkManagerProtocol.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import Foundation
import AppFoundation

protocol NetworkManagerProtocol: Sendable {
    func request(_ request: RequestProtocol) async throws -> (Data, URLResponse)
}

final class NetworkManager: NetworkManagerProtocol, @unchecked Sendable {
    @Injected(Dependencies.shared.urlSessionFactory) private var urlSession: URLSession
    init() {}
    func request(_ request: RequestProtocol) async throws -> (Data, URLResponse) {
        let apiRequest = try request.urlRequest()
        var lastError: Error = APIError.unknown

        for retryIndex in 0 ..< request.retryCount {
            try Task.checkCancellation()
            do {
                let (data, response) = try await urlSession.data(for: apiRequest)
                return try request.verifyResponse(data: data, response: response)
            } catch let apiError as APIError where [.badRequest, .authorizationError].contains(apiError) {
                throw apiError
            } catch where retryIndex < request.retryCount - 1 {
                try await Task.sleep(nanoseconds: request.retryDelay * UInt64(pow(2, Double(retryIndex))))
                lastError = error
                continue
            } catch {
                throw error
            }
        }

        throw lastError
    }
}
