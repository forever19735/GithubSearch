//
//  DecodableResponseTargetType.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import Moya

/// 定義一個 protocol 需要預先指定 response 的 type
protocol DecodableResponseTargetType: TargetType {
    associatedtype Response: Decodable
}
