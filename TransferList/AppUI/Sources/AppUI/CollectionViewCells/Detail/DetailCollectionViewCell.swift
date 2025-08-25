//
//  DetailCollectionViewCell.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import UIKit
import SDWebImage

final public class DetailCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    private struct Constants {
        static let buttonSize: CGFloat = 100
    }

    private var onButtonTap: (() -> Void)?
    @objc private func didTapOnButton() { onButtonTap?() }

    private lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            imageView, headerStackView, detailsTitle, detailStackView, UIView()
        ])
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        view.setCustomSpacing(20, after: headerStackView)
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraintSquare()
        return view
    }()
    private lazy var headerStackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            infoStackView,
            button
        ])
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var infoStackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .largeTitle
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .title2
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
    private lazy var detailsTitle: UILabel = {
        let view = UILabel()
        view.text = "Details: "
        view.textAlignment = .left
        view.font = .title
        return view
    }()
    private lazy var detailStackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()

    public func updateViews(with collectionItem: any CollectionViewItem) {
        guard let item = collectionItem.cellData as? DetailItemData else { return }
        onButtonTap = item.onButtonTap
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        imageView.sd_setImage(with: item.image)
        setDetails(to: item.details)
        button.setImage(item.buttonImage, for: .normal)
    }
    private func setDetails(to details: [String: String]?) {
        detailStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let details, !details.isEmpty else { return }
        detailStackView.addArrangedSubview(detailsTitle)
        details.sorted(by: { $0.key < $1.key }).forEach {
            detailStackView.addArrangedSubview(
                getDetailView(for: $0.key, value: $0.value)
            )
        }
    }
    private func getDetailView(for key: String, value: String) -> UIStackView {
        let keyLabel = UILabel()
        keyLabel.text = key
        keyLabel.font = .headline
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .title3
        valueLabel.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [keyLabel, UIView(), valueLabel])
        stack.spacing = 8
        return stack
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
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.constraintToEdges(of: contentView)
    }
}
