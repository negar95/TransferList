//
//  Untitled.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/22/25.
//

import UIKit

extension UIView {
    public func constraintToCenter(of view: UIView) {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    public func constraintToEdges(of view: UIView) {
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
    func constraintSquare() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        ])
    }
}
