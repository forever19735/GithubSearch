//
//  ConfigUI.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation

protocol ConfigUI {
    associatedtype ViewData
    func configure(viewData: ViewData)
}

extension ConfigUI {
    func configure(viewData: ViewData) {}
}
