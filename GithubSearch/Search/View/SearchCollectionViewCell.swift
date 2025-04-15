//
//  SearchCollectionViewCell.swift
//  GithubSearch
//
//  Created by 季紅 on 2025/4/14.
//

import UIKit

struct SearchViewData: Hashable {
    static func == (lhs: SearchViewData, rhs: SearchViewData) -> Bool {
        lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    let uuid = UUID().uuidString

    let item: Item
}

class SearchCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = SearchViewData
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 16), textColor: .black)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 12), textColor: .black)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(viewData: SearchViewData) {
        let item = viewData.item
        if let iconName = item.owner?.avatarURL {
            iconView.downloadImage(with: iconName)
        }
        nameLabel.text = item.name
        descriptionLabel.text = item.description
    }
}
private extension SearchCollectionViewCell {
    func setupConstraints() {
        stackView.addArrangeSubviews([nameLabel,descriptionLabel])
        contentView.addSubviews([iconView, stackView])
        iconView.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
        })
        stackView.snp.makeConstraints({
            $0.leading.equalTo(iconView.snp.trailing).offset(8)
            $0.bottom.top.trailing.equalToSuperview().inset(8)
        })
    }
}
