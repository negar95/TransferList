//
//  NSDirectionalEdgeInsets+Insets.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import UIKit

extension NSDirectionalEdgeInsets {
    init(_ inset: CGFloat) {
        self.init(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}
