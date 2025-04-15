//
//  UILabel + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

extension UILabel {
    func apply(font: UIFont,
               textColor: UIColor,
               textAlignment: NSTextAlignment = .left,
               numberOfLines: Int = 1,
               lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
    }
}
