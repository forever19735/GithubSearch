//
//  UIStackView + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

extension UIStackView {
    func addArrangeSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    func removeArrangeSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
