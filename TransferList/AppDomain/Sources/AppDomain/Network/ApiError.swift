//
//  ApiError.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import Foundation

enum ApiError: Error, Equatable {
    case badRequest
    case authorizationError
    case serverError
    case unknown
}
extension ApiError: CustomStringConvertible {
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
extension ApiError: LocalizedError {
    var errorDescription: String? { description }
}
