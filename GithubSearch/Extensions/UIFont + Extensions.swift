//
//  UIFont + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

extension UIFont {

    enum FontType {
        case pingFangBold
        case pingFangMedium
        case pingFangRegular
    }

    enum PingFangWeight: String {
        case Regular  = "PingFangTC-Regular"
        case Medium   = "PingFangTC-Medium"
        case Semibold = "PingFangTC-Semibold"
    }

    static func font(_ fontType: FontType, fontSize size: CGFloat) -> UIFont {
        switch fontType {
        case .pingFangBold:
            return UIFont(name: PingFangWeight.Semibold.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        case .pingFangMedium:
            return UIFont(name: PingFangWeight.Medium.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .pingFangRegular:
            return UIFont(name: PingFangWeight.Regular.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
}

