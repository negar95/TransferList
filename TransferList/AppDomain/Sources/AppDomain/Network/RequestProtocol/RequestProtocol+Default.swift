//
//  RequestProtocol+Default.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

extension RequestProtocol {
    var scheme: URLScheme { .https }
    var host: String { APIConfig.host }
    var baseURL: String { "\(scheme)://\(host)" }
    var timeoutInterval: TimeInterval { 30.0 }
    var retryDelay: UInt64 { 1_000_000_000 }
    var retryCount: Int { 3 }
    var headers: RequestHeaders? { nil }
    var parameters: RequestParameters? { nil }
}
