//
//  CollctionView+Delegate.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import UIKit

extension CollectionView: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard loading == .none, !sections.isEmpty else { return }
        let contentHeight = scrollView.contentSize.height
        let scrollPosition = scrollView.contentOffset.y + scrollView.frame.height
        guard scrollPosition > contentHeight - Constants.loadMoreThreshold else { return }
        onLoadMore?()
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.item]
        else { return }
        item.cellData.onTap?()
    }
}
