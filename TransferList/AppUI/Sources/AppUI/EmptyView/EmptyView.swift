//
//  EmptyView.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import UIKit

final class EmptyView: UIView {

    var title: String = "No Data" {
        didSet {
            titleLabel.text = title
        }
    }
    var iconName: String = "exclamationmark.triangle" {
        didSet {
            icon.image = UIImage(named: iconName)
        }
    }

    private struct Constants {
        static let iconSize: CGFloat = 50
    }
    private lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            icon, titleLabel
        ])
        view.distribution = .fill
        view.alignment = .center
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraintSquare(to: Constants.iconSize)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .body
        return view
    }()
    init() {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        addSubview(stackView)
        stackView.constraintToEdges(of: self)
    }
}
