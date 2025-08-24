//
//  InfoItemType.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import UIKit

public enum InfoItemType: Equatable {
    case compact
    case detailed(isFavorite: Bool)
}

extension InfoItemType {
    var configuration: InfoCollectionViewCell.Configuration {
        switch self {
        case .compact:
            return .init(
                direction: .vertical,
                spacing: 16,
                textAlignment: .center,
                buttonImage: nil,
                iconImage: nil,
            )
        case let .detailed(isFavorite):
            return .init(
                direction: .horizontal,
                spacing: 8,
                textAlignment: .left,
                buttonImage: isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"),
                iconImage: UIImage(systemName: "chevron.right")
            )
        }
    }
}
