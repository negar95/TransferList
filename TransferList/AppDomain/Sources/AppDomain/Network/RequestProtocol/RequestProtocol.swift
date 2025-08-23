//
//  RequestProtocol.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

typealias RequestHeaders = [String: String]
typealias RequestParameters = [String: Any]
enum RequestMethod: String { case get = "GET" }

protocol RequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var parameters: RequestParameters? { get }
    var headers: RequestHeaders? { get }
    var timeoutInterval: TimeInterval { get }
    var retryDelay: UInt64 { get }
    var retryCount: Int { get }

    func urlRequest() throws -> URLRequest
    func verifyResponse(data: Data, response: URLResponse) throws -> (Data, URLResponse)
}
