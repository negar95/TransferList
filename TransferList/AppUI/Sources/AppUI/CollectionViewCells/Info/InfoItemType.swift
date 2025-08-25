//
//  InfoItemType.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import UIKit

public enum InfoItemType: Equatable, Hashable {
    case compact
    case detailed(UIImage?)
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
        case let .detailed(buttonImage):
            return .init(
                direction: .horizontal,
                spacing: 8,
                textAlignment: .left,
                buttonImage: buttonImage,
                iconImage: .rightChevron
            )
        }
    }
}
