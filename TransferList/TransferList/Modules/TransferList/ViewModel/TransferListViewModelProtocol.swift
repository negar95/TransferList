//
//  TransferListViewModelProtocol.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Combine
import Foundation
import AppUI
import AppDomain

protocol TransferListViewModelProtocol {
    var state: CurrentValueSubject<TransferListViewModelState, Never> { get }
    func action(_ action: TransferListViewModelAction)
}
enum TransferListViewModelAction {
    case getTransfers
    case reload(refreshing: Bool)
}
enum TransferListDestination: Equatable {
    case openDetail(TransferModule.Configuration)
}

struct TransferListViewModelState {
    let pageToFetch: Page
    let transfers: [DestinationResponse]
    let favorites: [DestinationResponse]
    let sections: Loadable<[InfoSection]>
    let destination: TransferListDestination?

    func update(
        pageToFetch: Page?,
        transfers: [DestinationResponse]?,
        favorites: [DestinationResponse]?,
        sections: Loadable<[InfoSection]>?,
        destination: TransferListDestination?
    ) -> TransferListViewModelState {
        TransferListViewModelState(
            pageToFetch: pageToFetch ?? self.pageToFetch,
            transfers: transfers ?? self.transfers,
            favorites: favorites ?? self.favorites,
            sections: sections ?? self.sections,
            destination: destination
        )
    }
}
