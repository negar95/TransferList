//
//  CollectionViewItem.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit

public protocol CollectionViewSection {
    associatedtype ItemType: CollectionViewItem
    var items: [ItemType] { get }
    var layoutSection: NSCollectionLayoutSection { get }
}
public protocol CollectionViewItem {
    associatedtype CellType: UICollectionViewCell
    associatedtype DataType: IdentifiableItemData
    var cellType: CellType.Type { get }
    var cellData: DataType { get }
}
public protocol IdentifiableItemData {
    var stringId: String { get }
}
public protocol CollectionViewConfigurable: UICollectionViewCell {
    func updateViews(with item: any CollectionViewItem)
}
