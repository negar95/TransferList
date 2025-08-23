//
//  DestinationListRequest.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

enum DestinationListRequest {
    case list(page: Int)
}

extension DestinationListRequest: RequestProtocol {
    var method: RequestMethod { .get }
    var path: String {
        switch self {
        case let .list(page): "/transfer-list/\(page)"
        }
    }
}
