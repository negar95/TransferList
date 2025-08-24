//
//  CollectionViewItem.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit

public protocol CollectionViewSection {
    associatedtype ItemType: CollectionViewItem
    associatedtype HeaderType: CollectionViewHeader
    var items: [ItemType] { get }
    var header: HeaderType { get }
    var layoutSection: NSCollectionLayoutSection { get }
    var sectionId: String { get }
}
public protocol CollectionViewHeader: Equatable {
    associatedtype HeaderType: UICollectionReusableView
    associatedtype DataType: IdentifiableItemData
    var headerType: HeaderType.Type { get }
    var headerData: DataType { get }
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
public protocol ConfigurableCell: UICollectionViewCell {
    func updateViews(with item: any CollectionViewItem)
}
public protocol ConfigurableHeader: UICollectionReusableView {
    func updateViews(with header: any CollectionViewHeader)
}
