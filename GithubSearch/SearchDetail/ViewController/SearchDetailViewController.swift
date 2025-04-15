//
//  SearchDetailViewController.swift
//  GithubSearch
//
//  Created by 季紅 on 2025/4/14.
//

import UIKit

class SearchDetailViewController: BaseViewController {
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout)
        collectionView.register(cellWithClass: SearchDetailCollectionViewCell.self)
        return collectionView
    }()

    private lazy var collectionViewlayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { [unowned self] index, _ in
        let section = Section(rawValue: index) ?? .main
        let layout = generateLayoutSection(sectionType: section)
        return layout
    }
    
    private var item: Item?
    
    init(item: Item?) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item {
            configureDataSource(model: item)
        }
    }
    
    override func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}

private extension SearchDetailViewController {
    func generateLayoutSection(sectionType _: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)

        return section
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, SearchDetailViewData> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: SearchDetailCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: item)
            return cell
        }
    }

    func configureDataSource(model: Item) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchDetailViewData>()
        snapshot.appendSections(Section.allCases)
        
        let item = SearchDetailViewData(item: model)
        snapshot.appendItems([item])

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchDetailViewController {
    enum Section: Int, CaseIterable {
        case main
    }
}
