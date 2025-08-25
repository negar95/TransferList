//
//  RequestProtocol+URL.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

extension RequestProtocol {
    private var queryItems: [URLQueryItem]? {
        guard let parameters = parameters else { return nil }
        return parameters.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }

    private func url() throws -> URL {
        guard var urlComponents = URLComponents(string: baseURL) else { throw ApiError.badRequest }
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = queryItems
        guard let finalURL = urlComponents.url else { throw ApiError.badRequest }
        return finalURL
    }

    func urlRequest() throws -> URLRequest {
        let url = try url()
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    func verifyResponse(data: Data, response: URLResponse) throws -> (Data, URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else { throw ApiError.unknown }
        switch httpResponse.statusCode {
        case 200...299:
            return (data, response)
        case 401:
            throw ApiError.authorizationError
        case 400...499:
            throw ApiError.badRequest
        case 500...599:
            throw ApiError.serverError
        default:
            throw ApiError.unknown
        }
    }
}
