//
//  Reusable.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}
extension UICollectionViewCell: Reusable {
    nonisolated static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}
