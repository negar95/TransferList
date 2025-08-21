//
//  Reusable.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//



import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: Reusable {
    nonisolated public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}
