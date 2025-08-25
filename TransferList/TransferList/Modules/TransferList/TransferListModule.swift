//
//  TransferListModule.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/23/25.
//

enum TransferListModule {

    typealias Controller = TransferListViewController
    typealias ViewModel = TransferListViewModel

    static func build() -> Controller {
        let viewModel = ViewModel()
        return Controller(viewModel: viewModel)
    }
}
