//
//  APIManager.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import Moya

protocol APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(
        _ targetType: T,
        useSampleData: Bool
    ) async throws -> T.Response
}

final class APIManager {
    private let apiProviderFactory: APIProviderProtocol
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    static let shared = APIManager(apiProviderFactory: DefaultAPIProviderFactory())

    private init(apiProviderFactory: APIProviderProtocol) {
        self.apiProviderFactory = apiProviderFactory
    }
}

extension APIManager: APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(
        _ targetType: T,
        useSampleData: Bool = false
    ) async throws -> T.Response {
        let provider = apiProviderFactory.createProvider(useSampleData, targetType)

        return try await withCheckedThrowingContinuation { continuation in
            provider.request(targetType) { [weak self] result in
                guard let self = self else {
                    continuation.resume(throwing: APIError.unknown)
                    return
                }

                switch result {
                case .success(let response):
                    do {
                        let decoded = try self.decoder.decode(T.Response.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: APIError.decodeFailed(error))
                    }

                case .failure(let error):
                    continuation.resume(throwing: APIError.moyaError(error))
                }
            }
        }
    }
}
