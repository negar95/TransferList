//
//  TransferViewModel.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import Combine
import Foundation
import AppDomain
import AppUI
import AppFoundation

final class TransferViewModel: TransferViewModelProtocol {

    @UserDefault(\.favorites) private var favorites: [String]
    var state: CurrentValueSubject<TransferViewModelState, Never>
    var stateValue: TransferViewModelState {
        state.value
    }

    private var cancellables = Set<AnyCancellable>()

    init(response: DestinationResponse, isFavorite: Bool) {
        state = CurrentValueSubject<TransferViewModelState, Never>(
            TransferViewModelState(
                response: response,
                detailSection: nil
            )
        )
        subscribeToFavorites()
    }
    deinit {
        Logger.info("🗑️ TransferViewModel deinitialized")
    }
    private func subscribeToFavorites() {
        $favorites
            .sink { [weak self] favorites in
                guard let self else { return }
                updateFavorites(with: favorites)
            }
            .store(in: &cancellables)
    }
    private func updateFavorites(with favorites: [String]) {
        let currentResponse = stateValue.response
        let isFavorite = favorites.contains(currentResponse.id)
        updateState(isFavorite: isFavorite)
    }

    func action(_ action: TransferViewModelAction) {
        switch action {
        case let .addFavorite(id):
            addToFavorites(id)
        case let .removeFavorite(id):
            removeFromFavorites(id)
        }
    }
    private func updateState(isFavorite: Bool) {
        let response = stateValue.response
        let section = DetailSection(response: response, isFavorite: isFavorite) { [weak self] in
            guard let self else { return }
            isFavorite ? removeFromFavorites(response.id) : addToFavorites(response.id)
        }
        state.value = state.value.update(detailSection: section)
    }
    private func addToFavorites(_ id: String) {
        favorites.append(id)
    }
    private func removeFromFavorites(_ id: String) {
        favorites.removeAll { $0 == id }
    }
}

fileprivate extension DetailSection {
    init(response: DestinationResponse, isFavorite: Bool, onButtonTap: (() -> Void)?) {
        let data = DetailItemData(
            stringId: response.id + "_\(isFavorite)",
            title: response.person.fullName,
            subtitle: response.person.email,
            image: response.person.avatar,
            details: [
                "Card:": response.card.cardNumber.formattedCardNumber + "( \(response.card.cardType) )",
                "Last Transfer:": response.lastTransfer.formattedDate,
                "Total Transfers:": "\(response.moreInfo.numberOfTransfers)" + "($\(response.moreInfo.totalTransfer))",
                "Note:": response.note ?? "No notes"
            ],
            buttonImage: isFavorite ? .filledStar : .star,
            onButtonTap: onButtonTap
        )
        let item = DetailItem(cellType: DetailCollectionViewCell.self, cellData: data)
        self.init(
            sectionId: .detail,
            items: [item],
            layoutSection: .wholeContent
        )
    }
}
