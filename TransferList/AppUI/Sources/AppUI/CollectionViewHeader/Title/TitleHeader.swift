//
//  TitleHeader.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/24/25.
//

public struct TitleHeader: CollectionViewHeader, Equatable {
    public var headerType: TitleHeaderView.Type
    public var headerData: TitleHeaderData

    public init(headerType: TitleHeaderView.Type, headerData: TitleHeaderData) {
        self.headerType = headerType
        self.headerData = headerData
    }
    public static func ==(lhs: TitleHeader, rhs: TitleHeader) -> Bool {
        lhs.headerType == rhs.headerType &&
        lhs.headerData == rhs.headerData
    }
}
public struct TitleHeaderData: IdentifiableItemData, Equatable {
    public let stringId: String
    public let title: String

    public init(
        stringId: String,
        title: String
    ) {
        self.stringId = stringId
        self.title = title
    }
}
