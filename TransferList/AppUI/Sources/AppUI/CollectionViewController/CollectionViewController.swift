//
//  CollectionViewController.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit
import AppFoundation

final public class CollectionViewController: UICollectionViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>?
    private var registeredCells: Set<String> = []

    public var sections: [any CollectionViewSection] = [] {
        didSet {
            registerCells()
            setupLayout()
            setupDataSource()
            reload()
        }
    }

    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.sections[safe: sectionIndex]?.layoutSection ?? .vertical
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

    private func setupDataSource() {
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
