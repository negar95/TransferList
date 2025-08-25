//
//  Dependencies.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import AppFoundation
import Foundation
import AppDomain

final class Dependencies: @unchecked Sendable {
    static let shared = Dependencies()
    private init() {}

    private let lock = NSLock()
    private var _destinationListApi: DestinationListApiProtocol?

    var destinationListApiFactory: () -> DestinationListApiProtocol {
        return { [weak self] in
            guard let self else { return DestinationListApi() }
            return lock.withLock { [weak self] in
                guard let self else { return DestinationListApi() }
                if let existingValue = _destinationListApi { return existingValue }
                let newValue = DestinationListApi()
                _destinationListApi = newValue
                return newValue
            }
        }
    }
}
