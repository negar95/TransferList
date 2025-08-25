//
//  TransferListViewController.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import UIKit
import Combine
import AppUI
import AppFoundation

final class TransferListViewController: UIViewController {

    // MARK: - Constants
    
    enum Constants {
        static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 40, left: 0, bottom: 123, right: 0)
    }
    
    // MARK: - Properties
    
    lazy private var collectionView: CollectionView = {
        let view = CollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let viewModel: TransferListViewModelProtocol
    private var cancellable: Set<AnyCancellable>

    private var viewModelState: TransferListViewModelState {
        viewModel.state.value
    }

    // MARK: - Init
    
    init(
        viewModel: TransferListViewModelProtocol,
        cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    ) {
        self.viewModel = viewModel
        self.cancellable = cancellable
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.action(.reload(refreshing: false))
    }
    // MARK: - Setup
    
    private func setupView() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.constraintToEdges(of: view)
        collectionView.onRefresh = { [weak self] in
            self?.viewModel.action(.reload(refreshing: true))
        }
        collectionView.onLoadMore = { [weak self] in
            self?.viewModel.action(.getTransfers)
        }
    }

    // MARK: - Binding
    
    private func bind() {
        viewModel.state
            .map(\.destination)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] destination in
                guard let self, let destination else { return }
                handleDestination(destination)
            }.store(in: &cancellable)
        viewModel.state
            .map(\.sections)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                guard let self else { return }
                switch sections {
                case let .isLoading(refreshing):
                    collectionView.showEmpty = false
                    collectionView.loading = refreshing ? .refreshing : .loading
                case let .loaded(items):
                    collectionView.showEmpty = items.isEmpty
                    collectionView.loading = .none
                    collectionView.sections = items
                case .notRequested:
                    collectionView.showEmpty = false
                    collectionView.loading = .none
                    collectionView.sections = []
                case let .error(error):
                    collectionView.showEmpty = false
                    collectionView.loading = .none
                    collectionView.sections = []
                    showToast(message: error)
                }
            }.store(in: &cancellable)
    }
    // MARK: - Navigation
    
    private func handleDestination(_ destination: TransferListDestination) {
        switch destination {
        case let .openDetail(detailSection):
            openDetail(for: detailSection)
        }
    }
    
    private func openDetail(for configuration: TransferModule.Configuration) {
        let viewController = TransferModule.build(configuration: configuration)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
