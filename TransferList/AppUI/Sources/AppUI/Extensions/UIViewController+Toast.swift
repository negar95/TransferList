//
//  UIViewController+Toast.swift
//  AppUI
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import UIKit

extension UIViewController {

    public func showToast(
        message: String,
        color: UIColor = .red,
        duration: Double = 3.5
    ) {
        let padding: CGFloat = 25
        let height: CGFloat = 50
        let toastLabel = UILabel(
            frame: CGRect(
                x: padding,
                y: -height,
                width: view.frame.size.width - 2 * padding,
                height: height
            )
        )
        toastLabel.text = message
        toastLabel.textColor = color
        toastLabel.textAlignment = .center
        toastLabel.font = .body
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = .white.withAlphaComponent(0.7)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.layer.borderColor = color.cgColor
        toastLabel.layer.borderWidth = 1
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toastLabel.frame.origin.y = 2 * padding
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseInOut, animations: {
                toastLabel.frame.origin.y = -height
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

