//
//  InfoSection.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit

public struct InfoSection: CollectionViewSection {
    public let items: [InfoItem]
    public let layoutSection: NSCollectionLayoutSection

    public init(items: [InfoItem], layoutSection: NSCollectionLayoutSection) {
        self.items = items
        self.layoutSection = layoutSection
    }
}
public struct InfoItem: CollectionViewItem {
    public var cellType: InfoCollectionViewCell.Type
    public var cellData: InfoItemData

    public init(cellType: InfoCollectionViewCell.Type, cellData: InfoItemData) {
        self.cellType = cellType
        self.cellData = cellData
    }
}
public struct InfoItemData: IdentifiableItemData {
    public let stringId: String
    public let title: String
    public let subtitle: String
    public let image: URL?
    public let type: InfoItemType

    public init(stringId: String, title: String, subtitle: String, image: URL?, type: InfoItemType) {
        self.stringId = stringId
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
    }
}

