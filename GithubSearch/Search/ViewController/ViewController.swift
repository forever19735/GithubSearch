//
//  ViewController.swift
//  GithubSearch
//
//  Created by 季紅 on 2025/4/14.
//

import UIKit

class ViewController: BaseViewController, Refreshable, Loadable {
    var loadMoreAdaptor: LoadMoreAdaptor?

    var refreshAdaptor: RefreshAdaptor?

    private lazy var dataSource = makeDataSource()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout)
        collectionView.register(cellWithClass: SearchCollectionViewCell.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: SearchHeaderCollectionReusableView.self)

        collectionView.delegate = self
        return collectionView
    }()

    private lazy var collectionViewlayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { [unowned self] index, _ in
        let section = Section(rawValue: index) ?? .main
        let layout = generateLayoutSection(sectionType: section)
        return layout
    }

    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        setupNavigationBar(title: "Repositroy Search")
        refreshAdaptor = RefreshAdaptor(targetView: collectionView, delegate: self)
        loadMoreAdaptor = LoadMoreAdaptor(targetView: collectionView, delegate: self)
    }

    override func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController {
    private func binding() {
        viewModel.$searchText
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.viewModel.search(with: searchText)
            }
            .store(in: &cancellables)

        viewModel.$searchResult
            .receive(on: RunLoop.main)
            .sink { [weak self] searchResponse in
                guard let self = self else { return }
                self.configureDataSource(model: searchResponse)
            }
            .store(in: &cancellables)

        viewModel.$viewState
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .loading:
                    self.showLoading()
                case .loaded:
                    self.hideLoading()
                case let .error(message):
                    self.hideLoading()
                    self.showError(message)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
}

private extension ViewController {
    func generateLayoutSection(sectionType _: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.boundarySupplementaryItems = [createHeader()]

        return section
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, SearchViewData> {
        let dataSource = UICollectionViewDiffableDataSource<Section, SearchViewData>(collectionView: collectionView) {
            collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: SearchCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: item)
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        return dataSource
    }

    func configureDataSource(model: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchViewData>()
        snapshot.appendSections(Section.allCases)

        let items = model.map { SearchViewData(item: $0) }
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController {
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = false
        return header
    }

    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: SearchHeaderCollectionReusableView.self, for: indexPath)
        header.delegate = self
        return header
    }
}

extension ViewController {
    enum Section: Int, CaseIterable {
        case main
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewData = dataSource.snapshot().itemIdentifiers[indexPath.item]
        let vc = SearchDetailViewController(item: viewData.item)
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }

        let offsetY = scrollView.contentOffset.y

        if offsetY > navBarHeight {
            navigationController?.updateNavigationBarStyle(
                backgroundColor: .black,
                titleColor: .white
            )
        } else {
            navigationController?.updateNavigationBarStyle(
                backgroundColor: .white,
                titleColor: .black
            )
        }
    }
}

extension ViewController: SearchHeaderCollectionReusableViewDelegate {
    func searchHeaderCollectionReusableView(didChangeSearchText text: String) {
        viewModel.searchText = text
    }

    func searchHeaderCancelButtonClicked() {
        viewModel.clearResults()
    }
}

extension ViewController: RefreshAdaptorDelegate {
    func refreshAdaptorWillRefresh() {
        viewModel.refresh()
    }
}

extension ViewController: LoadMoreAdaptorDelegate {
    func loadMoreAdaptorWillLoadMore(pageNumber: Int) {
        viewModel.search(with: viewModel.searchText, page: pageNumber)
    }
}
