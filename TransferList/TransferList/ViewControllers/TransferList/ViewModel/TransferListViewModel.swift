//
//  TransferListViewModel.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Combine
import Foundation
import AppDomain
import AppUI
import AppFoundation

final class TransferListViewModel: TransferListViewModelProtocol {
    private enum Constants {
        static let startPage: UInt = 1
    }

    var state: CurrentValueSubject<TransferListViewModelState, Never>
    private var stateValue: TransferListViewModelState { state.value }
    @Injected(Dependencies.shared.destinationListApiFactory) private var api: DestinationListApiProtocol
    @UserDefault(UserDefaultKeys.favorites.rawValue, default: []) private var favorites: [String]
    private var loadingTask: Task<Void, Never>?

    init() {
        state = CurrentValueSubject<TransferListViewModelState, Never>(
            TransferListViewModelState(
                pageToFetch: .page(Constants.startPage),
                transfers: [],
                favorites: [],
                sections: .notRequested,
                destination: nil
            )
        )
    }
    deinit {
        loadingTask?.cancel()
    }

    func action(_ action: TransferListViewModelAction) {
        switch action {
        case .getTransfers:
            getTransfers()
        case .refresh:
            refresh()
        }
    }
    private func updateState(
        pageToFetch: Page? = nil,
        transfers: [DestinationResponse]? = nil,
        favorites: [DestinationResponse]? = nil,
        sections: Loadable<[InfoSection]>? = nil,
        destination: TransferListDestination? = nil
    ) {
        state.value = state.value.update(
            pageToFetch: pageToFetch,
            transfers: transfers,
            favorites: favorites,
            sections: sections,
            destination: destination
        )
    }
    private func getTransfers() {
        guard stateValue.sections != .isLoading,
              loadingTask == nil,
              case let .page(page) = stateValue.pageToFetch
        else { return }
        loadTransfers(page: page, currentList: stateValue.transfers)
    }
    private func refresh() {
        loadingTask?.cancel()
        updateState(pageToFetch: .page(Constants.startPage), transfers: nil, favorites: nil)
        loadTransfers(page: Constants.startPage, currentList: [])
    }
    private func getSections(
        for transfers: [DestinationResponse],
        withFavorites favorites: [DestinationResponse]
    ) -> Loadable<[InfoSection]> {
        let transferInfoItems = transfers.map { response in
            let isFavorite = favorites.contains(response)
            let data = InfoItemData(
                response,
                type: .detailed(isFavorite: isFavorite)
            ) { [weak self] in
                guard let self else { return }
                openDetail(for: response)
            } onButtonTap: { [weak self] in
                guard let self else { return }
                isFavorite ? removeFromFavorites(response.id) : addToFavorites(response.id)
            }
            let item = InfoItem(cellType: InfoCollectionViewCell.self, cellData: data)
            return item
        }
        let favoriteInfoItems = favorites.map { response in
            let data = InfoItemData(response, type: .compact, onButtonTap:  { [weak self] in
                guard let self else { return }
                openDetail(for: response)
            })
            let item = InfoItem(cellType: InfoCollectionViewCell.self, cellData: data)
            return item
        }
        return .loaded([
            InfoSection(items: favoriteInfoItems, layoutSection: .horizontal),
            InfoSection(items: transferInfoItems, layoutSection: .vertical)
        ])
    }
    private func loadTransfers(
        page: UInt,
        currentList: [DestinationResponse]
    ) {
        loadingTask?.cancel()
        let isFirstPage = page == Constants.startPage
        if isFirstPage {
            updateState(transfers: [], favorites: [], sections: .isLoading)
        }
        loadingTask = Task { [weak self] in
            guard let self else { return }
            do {
                let lists = try await api.list(page: page)
                guard !Task.isCancelled else { return }
                
                let nextPage: Page = lists.isEmpty ? .finished : .page(page + 1)
                var updatedList = currentList
                updatedList.append(contentsOf: lists)
                let fetchedFavorites = updatedList.filter { [favorites] in favorites.contains($0.id) }
                let sections = getSections(for: updatedList, withFavorites: fetchedFavorites)
                updateState(
                    pageToFetch: nextPage,
                    transfers: updatedList,
                    favorites: fetchedFavorites,
                    sections: sections
                )
            } catch let error {
                guard !Task.isCancelled else { return }
                updateState(sections: .error(error.localizedDescription))
            }
        }
    }
    private func updateFavorites() {
        let transfers = stateValue.transfers
        let updatedFavorites = transfers.filter { favorites.contains($0.id) }
        let sections = getSections(for: stateValue.transfers, withFavorites: updatedFavorites)
        updateState(
            favorites: updatedFavorites,
            sections: sections
        )
    }
    private func openDetail(for destination: DestinationResponse) {
        updateState(destination: .openDetail(destination))
    }
    private func addToFavorites(_ id: String) {
        favorites.append(id)
        updateFavorites()
    }
    private func removeFromFavorites(_ id: String) {
        favorites.removeAll { $0 == id }
        updateFavorites()
    }
}

fileprivate extension InfoItemData {
    init(
        _ destination: DestinationResponse,
        type: InfoItemType,
        onTap: (() -> Void)? = nil,
        onButtonTap: (() -> Void)? = nil
    ) {
        self.init(
            stringId: destination.id + type.hashValue.description,
            title: destination.fullName,
            subtitle: destination.email,
            image: destination.image,
            type: type,
            onTap: onTap,
            onButtonTap: onButtonTap
        )
    }
}
