//
//  InfoSection.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit

public enum InfoSectionId: String {
    case favorites
    case all
}

public struct InfoSection: CollectionViewSection, Equatable {
    public let sectionId: String
    public let items: [InfoItem]
    public let layoutSection: NSCollectionLayoutSection
    public let header: TitleHeader?

    public init(
        sectionId: InfoSectionId,
        items: [InfoItem],
        layoutSection: NSCollectionLayoutSection,
        header: TitleHeader? = nil
    ) {
        self.sectionId = sectionId.rawValue
        self.items = items
        self.layoutSection = layoutSection
        self.header = header
    }
}
public struct InfoItem: CollectionViewItem, Equatable {
    public var cellType: InfoCollectionViewCell.Type
    public var cellData: InfoItemData

    public init(cellType: InfoCollectionViewCell.Type, cellData: InfoItemData) {
        self.cellType = cellType
        self.cellData = cellData
    }
    public static func == (lhs: InfoItem, rhs: InfoItem) -> Bool {
        lhs.cellType == rhs.cellType &&
        lhs.cellData == rhs.cellData
    }
}
public struct InfoItemData: IdentifiableTappableItem, Equatable {
    public let stringId: String
    public let title: String
    public let subtitle: String?
    public let image: URL?
    public let type: InfoItemType
    public let onTap: (() -> Void)?
    public let onButtonTap: (() -> Void)?

    public init(
        stringId: String,
        title: String,
        subtitle: String?,
        image: URL?,
        type: InfoItemType,
        onTap: (() -> Void)? = nil,
        onButtonTap: (() -> Void)? = nil
    ) {
        self.stringId = stringId
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
        self.onTap = onTap
        self.onButtonTap = onButtonTap
    }
    public static func == (lhs: InfoItemData, rhs: InfoItemData) -> Bool {
        lhs.stringId == rhs.stringId &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.image == rhs.image &&
        lhs.type == rhs.type
    }
}
