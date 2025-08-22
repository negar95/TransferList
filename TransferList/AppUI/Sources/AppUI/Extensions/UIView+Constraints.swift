//
//  Untitled.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import UIKit

extension UIView {
    func constraintToEdges(_ view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func constraintSquare(to edgeSize: CGFloat) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: edgeSize),
            heightAnchor.constraint(equalToConstant: edgeSize)
        ])
    }
}
