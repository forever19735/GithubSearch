//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by 季紅 on 2025/4/14.
//
import Combine

enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}

class SearchViewModel {
    @Published var searchText: String = ""

    @Published var searchResult: [Item] = []

    @Published var viewState: ViewState = .idle
}

extension SearchViewModel {
    func search(with query: String, page: Int = 1) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            searchResult = []
            viewState = .error("请输入搜索内容")
            return
        }
        if page == 1 {
            searchResult = []
            searchText = trimmed
        }
        
        viewState = .loading
        Task {
            do {
                let targetType = SearchAPI.GetSearch(q: searchText, sort: nil, order: nil, perPage: nil, page: page)
                let response = try await APIManager.shared.request(targetType)
                print("總數：\(response.totalCount)")
                searchResult += response.items
                viewState = .loaded
                
            } catch {
                viewState = .error(error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        searchResult = []
        search(with: searchText)
    }
    
    func clearResults() {
        searchResult = []
        searchText = ""
        viewState = .idle
     }
}
