//
//  TransferViewModelProtocol.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import Combine
import Foundation
import AppUI
import AppDomain

protocol TransferViewModelProtocol {
    var state: CurrentValueSubject<TransferViewModelState, Never> { get }
    func action(_ action: TransferViewModelAction)
}
enum TransferViewModelAction {
    case addFavorite(String)
    case removeFavorite(String)
}
struct TransferViewModelState {
    let response: DestinationResponse
    let detailSection: DetailSection?
    func update(detailSection: DetailSection) -> TransferViewModelState {
        TransferViewModelState(
            response: response,
            detailSection: detailSection
        )
    }
}
