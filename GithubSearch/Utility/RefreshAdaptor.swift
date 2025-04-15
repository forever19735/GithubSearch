//
//  RefreshAdaptor.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import MJRefresh
import UIKit

protocol RefreshProtocol {
    var targetView: UIScrollView { get set }
    func setupRefresh()
}

@objc protocol RefreshAdaptorDelegate: AnyObject {
    @objc optional func refreshAdaptorWillRefresh()
}

class RefreshAdaptor: NSObject, RefreshProtocol {
    weak var delegate: RefreshAdaptorDelegate?

    var targetView: UIScrollView

    init(targetView: UIScrollView, delegate: RefreshAdaptorDelegate?) {
        self.targetView = targetView
        super.init()
        self.delegate = delegate
        setupRefresh()
    }

    func setupRefresh() {
        targetView.addRefreshHeader(target: self, selector: #selector(refresh))
    }

    @objc func refresh() {
        delegate?.refreshAdaptorWillRefresh?()
        targetView.mj_header?.endRefreshing()
    }
}
