//
//  UIImageView + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Kingfisher
import UIKit

extension UIImageView {
    func downloadImage(with urlString: String, placeHolder: UIImage? = nil) {
        if let url = URL(string: urlString) {
            kf.setImage(with: url, placeholder: placeHolder)
        } else {
            image = placeHolder
        }
    }
}

extension UIButton {
    func downloadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            kf.setImage(with: url, for: .normal)
        }
    }
}

