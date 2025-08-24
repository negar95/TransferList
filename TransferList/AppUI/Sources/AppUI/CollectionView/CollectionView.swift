//
//  CollectionView.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit
import AppFoundation

public enum CollectionViewLoading {
    case loading
    case refreshing
    case none
}
final public class CollectionView: UIView {

    enum Constants {
        static let loadMoreThreshold: CGFloat = 100
    }
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        return control
    }()
    private lazy var emptyView: EmptyView = EmptyView()
    private lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>?
    private var registeredCells: Set<String> = []

    public var sections: [any CollectionViewSection] = [] {
        didSet { updateViews() }
    }
    public var showEmpty: Bool = false {
        didSet { updateEmptyView() }
    }
    public var loading: CollectionViewLoading = .none {
        didSet { updateLoadingView() }
    }
    public var onRefresh: (() -> Void)?
    public var onLoadMore: (() -> Void)?

    public init() {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        addSubview(collectionView)
        collectionView.constraintToEdges(of: self)
        collectionView.refreshControl = refreshControl
    }
    @objc private func didRefresh() {
        onRefresh?()
    }
    private func updateViews() {
        updateCollectionView()
        updateEmptyView()
        updateLoadingView()
    }
    private func updateCollectionView() {
        guard !sections.isEmpty else { return }
        registerCells()
        setupLayout()
        setupDataSource()
        reload()
    }
    private func updateEmptyView() {
        collectionView.backgroundView = showEmpty ? emptyView : nil
    }
    private func updateLoadingView() {
        switch loading {
        case .loading:
            loadingView.startAnimating()
            collectionView.backgroundView = loadingView
            refreshControl.endRefreshing()
        case .refreshing:
            loadingView.stopAnimating()
            collectionView.backgroundView = nil
            refreshControl.beginRefreshing()
        case .none:
            loadingView.stopAnimating()
            collectionView.backgroundView = nil
            refreshControl.endRefreshing()
        }
    }
    private func registerCells() {
        for section in sections {
            for item in section.items {
                let identifier = item.cellType.reuseIdentifier
                if !registeredCells.contains(identifier) {
                    collectionView.registerCell(item.cellType)
                    registeredCells.insert(identifier)
                }
            }
        }
    }
    private func setupLayout() {
        guard collectionView.collectionViewLayout is UICollectionViewFlowLayout else { return }
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.sections[safe: sectionIndex]?.layoutSection ?? .vertical
        }
    }
    private func setupDataSource() {
        guard dataSource == nil else { return }
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, itemIdentifier in

            guard let self,
                  let section = self.sections[safe: indexPath.section],
                  let item = section.items[safe: indexPath.item]
            else {
                print("Can't get collection view item for indexPath: \(indexPath)")
                return UICollectionViewCell()
            }
            let reuseIdentifier = item.cellType.reuseIdentifier
            guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? CollectionViewConfigurable
            else {
                print("Can't get collection view cell for indexPath: \(indexPath), reuseIdentifier: \(reuseIdentifier)")
                return UICollectionViewCell()
            }
            cell.updateViews(with: item)
            return cell
        }
    }

    private func reload() {
        guard let dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        for (sectionIndex, section) in sections.enumerated() {
            snapshot.appendSections([sectionIndex])
            let items = section.items.map { $0.cellData.stringId }
            snapshot.appendItems(items, toSection: sectionIndex)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
