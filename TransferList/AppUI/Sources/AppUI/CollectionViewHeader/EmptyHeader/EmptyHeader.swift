//
//  EmptyHeader.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import UIKit

public struct EmptyHeader: CollectionViewHeader, Equatable {
    public var headerType: UICollectionReusableView.Type
    public var headerData: EmptyHeaderData

    public init(headerType: UICollectionReusableView.Type, headerData: EmptyHeaderData) {
        self.headerType = headerType
        self.headerData = headerData
    }
    public static func ==(lhs: EmptyHeader, rhs: EmptyHeader) -> Bool {
        lhs.headerType == rhs.headerType &&
        lhs.headerData == rhs.headerData
    }
}
public struct EmptyHeaderData: IdentifiableTappableItem, Equatable {
    public let stringId: String = ""
}
