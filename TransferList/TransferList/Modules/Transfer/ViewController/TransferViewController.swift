//
//  TransferViewController.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import UIKit
import Combine
import AppUI

final class TransferViewController: UIViewController {

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

    let viewModel: TransferViewModelProtocol
    private var viewModelState: TransferViewModelState {
        viewModel.state.value
    }
    private var cancellable: Set<AnyCancellable>

    // MARK: - Init
    init(
        viewModel: TransferViewModelProtocol,
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
    }

    // MARK: - Setup
    private func setupView() {
        setupCollectionView()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.constraintToEdges(of: view)
    }

    // MARK: - Binding
    private func bind() {
        viewModel.state
            .compactMap(\.detailSection)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] section in
                guard let self else { return }
                collectionView.sections = [section]
            }.store(in: &cancellable)
    }
}
