//
//  BaseViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Combine
import UIKit

class BaseViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()

    deinit {
        debugPrint("deinit \(NSStringFromClass(type(of: self)))")
        cancellables.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
    }

    func setupUI() {

    }
}

