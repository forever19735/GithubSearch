//
//  SearchHeaderCollectionReusableView.swift
//  GithubSearch
//
//  Created by 季紅 on 2025/4/15.
//

import UIKit

protocol SearchHeaderCollectionReusableViewDelegate: AnyObject {
    func searchHeaderCollectionReusableView(didChangeSearchText text: String)
    func searchHeaderCancelButtonClicked()
}

class SearchHeaderCollectionReusableView: UICollectionReusableView {
    weak var delegate: SearchHeaderCollectionReusableViewDelegate?

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.cornerRadius = 6
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.placeholder = "請輸入關鍵字搜尋"
        searchBar.delegate = self
        return searchBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchHeaderCollectionReusableView {
    func setupConstraint() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SearchHeaderCollectionReusableView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_: UISearchBar) {
        delegate?.searchHeaderCancelButtonClicked()
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        delegate?.searchHeaderCollectionReusableView(didChangeSearchText: searchText)
    }
}
