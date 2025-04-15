//
//  SearchDetailCollectionViewCell.swift
//  GithubSearch
//
//  Created by 季紅 on 2025/4/14.
//

import UIKit

struct SearchDetailViewData: Hashable {
    static func == (lhs: SearchDetailViewData, rhs: SearchDetailViewData) -> Bool {
        lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    let uuid = UUID().uuidString

    let item: Item
}

class SearchDetailCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = SearchDetailViewData
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 20), textColor: .black, textAlignment: .center)
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 14), textColor: .black)
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 12), textColor: .black)
        return label
    }()
    
    private let watcherLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 12), textColor: .black)
        return label
    }()
    
    private let forkLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 12), textColor: .black)
        return label
    }()
    
    private let issueLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 12), textColor: .black)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewData: SearchDetailViewData) {
        let item = viewData.item
        if let iconName = item.owner?.avatarURL {
            iconView.downloadImage(with: iconName)
        }
        nameLabel.text = "\(item.name ?? "")/\(item.language ?? "")"
        languageLabel.text = "Written in \(item.language ?? "")"
        starsLabel.text = "\(item.stargazersCount ?? 0) stars"
        watcherLabel.text = "\(item.watchersCount  ?? 0) watchers"
        forkLabel.text = "\(item.forksCount ?? 0) forks"
        issueLabel.text = "\(item.openIssuesCount ?? 0) open issues"

    }
}

private extension SearchDetailCollectionViewCell {
    func setupConstraints() {
        stackView.addArrangeSubviews([starsLabel, watcherLabel, forkLabel, issueLabel])
        contentView.addSubviews([iconView, nameLabel, languageLabel, stackView])
        iconView.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview().inset(16)
        })
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(iconView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        })
        languageLabel.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        })
        stackView.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(languageLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().inset(12)
        })
    }
}
