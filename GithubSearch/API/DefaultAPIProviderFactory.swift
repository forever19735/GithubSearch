//
//  DefaultAPIProviderFactory.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import Moya

protocol APIProviderProtocol {
    func createProvider<T>(_ useSampleData: Bool, _ targetType: T) -> MoyaProvider<T>
}

class DefaultAPIProviderFactory: APIProviderProtocol {
    private let networkActivityPlugin = NetworkActivityPlugin.init { changeType, _ in

        switch changeType {
        case .began:
            break
        case .ended:
            break
        }
    }

    func createProvider<T>(_: Bool, _: T) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            plugins: [networkActivityPlugin]
        )
    }
}
