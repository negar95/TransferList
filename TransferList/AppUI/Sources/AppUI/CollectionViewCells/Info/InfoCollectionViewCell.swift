//
//  InfoCollectionViewCell.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/21/25.
//

import UIKit
import SDWebImage

final public class InfoCollectionViewCell: UICollectionViewCell, CollectionViewConfigurable {

    private struct Constants {
        static let imageSize: CGFloat = 50
        static let iconSize: CGFloat = 20
        static let buttonSize: CGFloat = 40
    }
    struct Configuration {
        let direction: NSLayoutConstraint.Axis
        let spacing: CGFloat
        let textAlignment: NSTextAlignment
        let buttonImage: UIImage?
        let iconImage: UIImage?

    }

    private var onButtonTap: (() -> Void)?
    @objc private func didTapOnButton() { onButtonTap?() }

    private lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            imageView, infoStackView, button, icon
        ])
        view.distribution = .fill
        view.alignment = .center
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraintSquare(to: Constants.imageSize)
        view.layer.cornerRadius = Constants.imageSize / 2
        view.clipsToBounds = true
        return view
    }()
    private lazy var infoStackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .body
        return view
    }()
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .description
        return view
    }()
    private lazy var button: UIButton = {
        let view = UIButton(type: .custom)
        view.tintColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraintSquare(to: Constants.buttonSize)
        view.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        return view
    }()
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .gray
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraintSquare(to: Constants.iconSize)
        return view
    }()

    public func updateViews(with collectionItem: any CollectionViewItem) {
        guard let item = collectionItem.cellData as? InfoItemData else { return }
        onButtonTap = item.onButtonTap
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        imageView.sd_setImage(with: item.image)
        configureViews(with: item.type.configuration)
    }
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        onButtonTap = nil
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupConstraints() {
        stackView.constraintToEdges(of: contentView)
    }
    private func setupViews() {
        contentView.addSubview(stackView)
        setupConstraints()
    }
    private func configureViews(with config: Configuration) {
        stackView.axis = config.direction
        stackView.spacing = config.spacing
        titleLabel.textAlignment = config.textAlignment
        subtitleLabel.textAlignment = config.textAlignment
        if let buttonImage = config.buttonImage {
            button.setImage(buttonImage, for: .normal)
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        if let iconImage = config.iconImage {
            icon.image = iconImage
            icon.isHidden = false
        } else {
            icon.isHidden = true
        }
    }
}
