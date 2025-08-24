//
//  TitleHeaderView.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import UIKit

public final class TitleHeaderView: UICollectionReusableView, ConfigurableHeader {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .headline
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.constraintToEdges(of: self)
    }
    public func updateViews(with header: any CollectionViewHeader) {
        guard let data = header.headerData as? TitleHeaderData else { return }
        titleLabel.text = data.title
    }
}
