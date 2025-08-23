//
//  APIError.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import Foundation

enum APIError: Error, Equatable {
    case badRequest
    case authorizationError
    case serverError
    case unknown
}
extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .badRequest:
            return "bad request"
        case .authorizationError:
            return "authorization error"
        case .serverError:
            return "server error"
        case .unknown:
            return "unknown error"
        }
    }
}
extension APIError: LocalizedError {
    var errorDescription: String? { description }
}
