//
//  APIError.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import Moya

enum APIError: Error {
    case moyaError(MoyaError)
    case decodeFailed(Error)
    case unknown
    case responseHasNoData(status: Int, message: String, error_code: String)
    case responseConvertToItemFailed
}
