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

    // MARK: - Constants
    private enum Constants {
        static let startPage: UInt = 1
        static let favoriteHeader: TitleHeader = TitleHeader(
            headerType: TitleHeaderView.self,
            headerData: TitleHeaderData(stringId: .favorites, title: "Favorties")
        )
        static let allHeader: TitleHeader = TitleHeader(
            headerType: TitleHeaderView.self,
            headerData: TitleHeaderData(stringId: .all, title: "All")
        )
    }

    // MARK: - Properties
    @Injected(Dependencies.shared.destinationListApiFactory) private var api: DestinationListApiProtocol
    @UserDefault(\.favorites) private var favorites: [String]

    var state: CurrentValueSubject<TransferListViewModelState, Never>
    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    private var stateValue: TransferListViewModelState { state.value }

    // MARK: - Init/Deinit
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
        subscribeToFavorites()
    }

    deinit {
        loadingTask?.cancel()
        Logger.info("TransferListViewModel deinitialized")
    }

    // MARK: - Subscription Management
    private func subscribeToFavorites() {
        $favorites
            .sink { [weak self] favorites in
                guard let self else { return }
                self.updateFavorites(with: favorites)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    func action(_ action: TransferListViewModelAction) {
        switch action {
        case .getTransfers:
            getTransfers()
        case let .reload(refreshing):
            reload(refreshing: refreshing)
        }
    }

    // MARK: - State Management
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

    // MARK: - Data Loading
    private func getTransfers() {
        guard stateValue.sections != .isLoading(), loadingTask == nil
        else { return Logger.info("Already loading transfers") }
        loadTransfers()
    }

    private func reload(refreshing: Bool) {
        guard stateValue.sections != .isLoading(), loadingTask == nil
        else { return Logger.info("Already loading transfers") }
        loadingTask?.cancel()
        updateState(pageToFetch: .page(Constants.startPage), transfers: [], favorites: [])
        loadTransfers(refreshing: refreshing)
    }

    // MARK: - Section Building
    private func getSections(
        for transfers: [DestinationResponse],
        withFavorites favorites: [DestinationResponse]
    ) -> Loadable<[InfoSection]> {
        let favoriteInfoItems = favorites.map { response in
            let data = InfoItemData(response, type: .compact, onButtonTap:  { [weak self] in
                guard let self else { return }
                openDetail(for: response)
            })
            let item = InfoItem(cellType: InfoCollectionViewCell.self, cellData: data)
            return item
        }
        let transferInfoItems = transfers.map { response in
            let isFavorite = favorites.contains(response)
            let data = InfoItemData(
                response,
                type: .detailed(isFavorite ? .filledStar : .star)
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
        var sections: [InfoSection] = []
        if !favoriteInfoItems.isEmpty {
            sections.append(InfoSection(
                sectionId: .favorites,
                items: favoriteInfoItems,
                layoutSection: .horizontal,
                header: Constants.favoriteHeader
            ))
        }
        if !transferInfoItems.isEmpty {
            sections.append(InfoSection(
                sectionId: .all,
                items: transferInfoItems,
                layoutSection: .vertical,
                header: Constants.allHeader
            ))
        }
        return .loaded(sections)
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
                let lists: [DestinationResponse] = try await api.list(page: page)
                guard !Task.isCancelled else { return Logger.info("Task cancelled") }
                let nextPage: Page = lists.isEmpty ? .finished : .page(page + 1)
                var updatedList = currentList
                updatedList.append(contentsOf: lists)
                let fetchedFavorites = updatedList.filter { [favorites] in favorites.contains($0.id) }
                let sections = getSections(for: updatedList, withFavorites: fetchedFavorites)
                Logger.info("Next page: ", nextPage)
                Logger.info("Updated list count: ", updatedList.count)
                Logger.info("Fetched favorites ids: ", fetchedFavorites.map { $0.id })
                updateState(
                    pageToFetch: nextPage,
                    transfers: updatedList,
                    favorites: fetchedFavorites,
                    sections: sections
                )
                loadingTask = nil
            } catch let error {
                guard !Task.isCancelled else { return Logger.info("Task cancelled") }
                updateState(sections: .error(error.localizedDescription))
                Logger.error("Error: ", error)
                loadingTask = nil
            }
        }
    }

    // MARK: - Private Methods
    private func updateFavorites(with favorites: [String]) {
        let transfers = stateValue.transfers
        guard !transfers.isEmpty else {
            return Logger.error("can't updateFavorites with empty transfers")
        }
        let updatedFavorites = transfers.filter { favorites.contains($0.id) }
        let sections = getSections(for: stateValue.transfers, withFavorites: updatedFavorites)
        updateState(
            favorites: updatedFavorites,
            sections: sections
        )
    }

    private func openDetail(for response: DestinationResponse) {
        let isFavorite = favorites.contains(response.id)
        let configuration = TransferModule.Configuration(response: response, isFavorite: isFavorite)
        updateState(destination: .openDetail(configuration))
        updateState()
    }

    private func addToFavorites(_ id: String) {
        favorites.append(id)
    }

    private func removeFromFavorites(_ id: String) {
        favorites.removeAll { $0 == id }
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
            title: destination.person.fullName,
            subtitle: destination.person.email,
            image: destination.person.avatar,
            type: type,
            onTap: onTap,
            onButtonTap: onButtonTap
        )
    }
}
