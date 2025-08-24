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

    @Injected(Dependencies.shared.destinationListApiFactory) private var api: DestinationListApiProtocol
    @UserDefault(UserDefaultKeys.favorites.rawValue, default: []) private var favorites: [String]

    var state: CurrentValueSubject<TransferListViewModelState, Never>
    private var loadingTask: Task<Void, Never>?

    private var stateValue: TransferListViewModelState { state.value }

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
        guard stateValue.sections != .isLoading()
        else { return Logger.info("Already loading transfers") }
        loadTransfers()
    }
    private func refresh() {
        guard stateValue.sections != .isLoading()
        else { return Logger.info("Already loading transfers") }
        loadingTask?.cancel()
        updateState(pageToFetch: .page(Constants.startPage), transfers: [], favorites: [])
        loadTransfers(refreshing: true)
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
    private func loadTransfers(refreshing: Bool = false) {
        Logger.info("refreshing: ", refreshing)
        Logger.info("page: ", stateValue.pageToFetch)
        guard case let .page(page) = stateValue.pageToFetch else { return }
        loadingTask?.cancel()

        let isFirstPage = page == Constants.startPage
        let currentList: [DestinationResponse]
        if isFirstPage {
            currentList = []
            updateState(sections: .isLoading(refreshing: refreshing))
        } else {
            currentList = stateValue.transfers
        }
        Logger.info("Current list count: ", currentList.count)
        loadingTask = Task { [weak self] in
            guard let self else { return }
            do {
                let lists = try await api.list(page: page)
                guard !Task.isCancelled else { return Logger.info("Task cancelled") }
                let nextPage: Page = lists.isEmpty ? .finished : .page(page + 1)
                var updatedList = currentList
                updatedList.append(contentsOf: lists)
                let fetchedFavorites = updatedList.filter { [favorites] in favorites.contains($0.id) }
                let sections = getSections(for: updatedList, withFavorites: fetchedFavorites)
                Logger.info("Next page: ", nextPage)
                Logger.info("Updated list count: ", updatedList.count)
                Logger.info("Fetched favorites names: ", fetchedFavorites.map { $0.fullName })
                updateState(
                    pageToFetch: nextPage,
                    transfers: updatedList,
                    favorites: fetchedFavorites,
                    sections: sections
                )
            } catch let error {
                guard !Task.isCancelled else { return Logger.info("Task cancelled") }
                updateState(sections: .error(error.localizedDescription))
                Logger.error("Error: ", error)
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
