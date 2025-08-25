//
//  TransferModule.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import AppUI
import AppDomain

enum TransferModule {
    typealias Controller = TransferViewController
    typealias ViewModel = TransferViewModel

    struct Configuration: Equatable {
        let response: DestinationResponse
        let isFavorite: Bool
    }
    static func build(configuration: Configuration) -> Controller {
        let viewModel = ViewModel(response: configuration.response, isFavorite: configuration.isFavorite)
        return Controller(viewModel: viewModel)
    }
}
