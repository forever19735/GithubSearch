//
//  UserAPITargetType.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import Foundation
import Moya

protocol SearchAPITargetType: DecodableResponseTargetType {}

extension SearchAPITargetType {
    var baseURL: URL { URL(string: "https://api.github.com")! }

    var method: Moya.Method { .get }

    var headers: [String: String]? {
        return ["Accept": "application/vnd.github.v3+json"]
    }

    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
}

enum SearchAPI {
    struct GetSearch: SearchAPITargetType {
        typealias Response = SearchResponse

        var path: String { "/search/repositories" }

        var parameter: [String: Any] {
            let raw: [String: Any?] = [
                "q": q,
                "sort": sort,
                "order": order,
                "per_page": perPage,
                "page": page,
            ]
            return raw.compactMapValues { $0 }
        }

        var task: Task { .requestParameters(parameters: parameter, encoding: URLEncoding.queryString) }

        private let q: String
        private let sort: String?
        private let order: String?
        private let perPage: Int?
        private let page: Int?

        init(q: String, sort: String?, order: String?, perPage: Int?, page: Int?) {
            self.q = q
            self.sort = sort
            self.order = order
            self.perPage = perPage
            self.page = page
        }
    }
}
