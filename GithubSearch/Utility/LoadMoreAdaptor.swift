//
//  LoadMoreAdaptor.swift
//  Carguru_c2b2c
//
//  Created by 雷翎 on 2022/8/31.
//

import MJRefresh
import UIKit

@objc protocol LoadMoreAdaptorDelegate: AnyObject {
    @objc optional func loadMoreAdaptorWillLoadMore(pageNumber: Int)
}

class LoadMoreAdaptor: NSObject, RefreshProtocol {
    private var isLastPage: Bool = false
    var pageNumber: Int = 1

    weak var delegate: LoadMoreAdaptorDelegate?
    var targetView: UIScrollView

    init(targetView: UIScrollView, delegate: LoadMoreAdaptorDelegate?) {
        self.targetView = targetView
        super.init()
        self.delegate = delegate
        setupRefresh()
    }

    func setupRefresh() {
        targetView.addRefreshFooter(target: self, selector: #selector(loadMore))
    }

    @objc func loadMore() {
        guard !isLastPage else {
            targetView.mj_footer?.endRefreshingWithNoMoreData()
            return
        }
        pageNumber += 1
        delegate?.loadMoreAdaptorWillLoadMore?(pageNumber: pageNumber)
        targetView.mj_footer?.endRefreshing()
    }

    func update(itemsCount: Int) {
        isLastPage = itemsCount == 0 ? true : false
    }
}
