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
    private var dataSource: UICollectionViewDiffableDataSource<String, String>?
    private var registeredReusables: Set<String> = []

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
        Logger.info("Sections count: \(sections.count)")
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
            collectionView.backgroundView = showEmpty ? emptyView : nil
            refreshControl.beginRefreshing()
        case .none:
            loadingView.stopAnimating()
            collectionView.backgroundView = showEmpty ? emptyView : nil
            refreshControl.endRefreshing()
        }
    }
    private func registerCells() {
        for section in sections {
            let identifier = section.header.headerType.reuseIdentifier
            if !registeredReusables.contains(identifier) {
                collectionView.registerHeader(section.header.headerType)
                registeredReusables.insert(identifier)
            }
            for item in section.items {
                let identifier = item.cellType.reuseIdentifier
                if !registeredReusables.contains(identifier) {
                    collectionView.registerCell(item.cellType)
                    registeredReusables.insert(identifier)
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
        dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, itemIdentifier in
            guard let self,
                  let section = self.sections[safe: indexPath.section],
                  let item = section.items[safe: indexPath.item]
            else {
                Logger.error("Can't get item for indexPath:", indexPath)
                return UICollectionViewCell()
            }
            Logger.info("Item for indexPath: \(indexPath) is: \(item.cellData)")
            let reuseIdentifier = item.cellType.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? ConfigurableCell
            else {
                Logger.error("Can't get ConfigurableCell")
                return UICollectionViewCell()
            }
            cell.updateViews(with: item)
            Logger.info("ConfigurableCell is updated")
            return cell
        }
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader
            else {
                Logger.warning("Unsupported kind: \(kind)")
                return nil
            }
            guard let sectionHeader = self?.sections[safe: indexPath.section]?.header
            else {
                Logger.error("Can't get header for indexPath:", indexPath)
                return nil
            }
            Logger.info("Header for indexPath: \(indexPath) is: \(sectionHeader)")
            let reuseIdentifier = sectionHeader.headerType.reuseIdentifier
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? ConfigurableHeader else {
                Logger.error("Can't get ConfigurableHeader")
                return nil
            }
            header.updateViews(with: sectionHeader)
            Logger.info("ConfigurableHeader is updated")
            return header
        }
    }

    private func reload() {
        guard let dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        for section in sections {
            snapshot.appendSections([section.sectionId])
            let items = section.items.map { $0.cellData.stringId }
            snapshot.appendItems(items, toSection: section.sectionId)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
