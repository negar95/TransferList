//
//  DetailSection.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import UIKit

public enum DetailSectionId: String {
    case detail
}

public struct DetailSection: CollectionViewSection, Equatable {
    public let sectionId: String
    public let items: [DetailItem]
    public let layoutSection: NSCollectionLayoutSection
    public let header: EmptyHeader? = nil

    public init(
        sectionId: DetailSectionId,
        items: [DetailItem],
        layoutSection: NSCollectionLayoutSection
    ) {
        self.sectionId = sectionId.rawValue
        self.items = items
        self.layoutSection = layoutSection
    }

    public static func == (lhs: DetailSection, rhs: DetailSection) -> Bool {
        lhs.sectionId == rhs.sectionId &&
        lhs.items == rhs.items &&
        lhs.layoutSection == rhs.layoutSection
    }
}
public struct DetailItem: CollectionViewItem, Equatable {
    public var cellType: DetailCollectionViewCell.Type
    public var cellData: DetailItemData

    public init(cellType: DetailCollectionViewCell.Type, cellData: DetailItemData) {
        self.cellType = cellType
        self.cellData = cellData
    }
    public static func == (lhs: DetailItem, rhs: DetailItem) -> Bool {
        lhs.cellType == rhs.cellType &&
        lhs.cellData == rhs.cellData
    }
}
public struct DetailItemData: IdentifiableItem, Equatable {
    public let stringId: String
    public let title: String
    public let subtitle: String?
    public let image: URL?
    public let details: [String: String]?
    public let buttonImage: UIImage?
    public let onButtonTap: (() -> Void)?

    public init(
        stringId: String,
        title: String,
        subtitle: String?,
        image: URL?,
        details: [String: String]?,
        buttonImage: UIImage?,
        onButtonTap: (() -> Void)?
    ) {
        self.stringId = stringId
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.details = details
        self.buttonImage = buttonImage
        self.onButtonTap = onButtonTap
    }
    public static func == (lhs: DetailItemData, rhs: DetailItemData) -> Bool {
        lhs.stringId == rhs.stringId &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.image == rhs.image &&
        lhs.details == rhs.details &&
        lhs.buttonImage == rhs.buttonImage
    }
}

