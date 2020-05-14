//
//  ConfigRequest.swift
//  Medicare
//
//  Created by Thuan on 4/29/20.
//

import Foundation
import Moya

enum ConfigRequest {
    case getConfig(_ type: String, key: String)
}

extension ConfigRequest: TargetType {

    var path: String {
        switch self {
        case .getConfig:
            return "user/config"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getConfig:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getConfig(let type, let key):
            return .requestParameters(parameters: ["type": type, "key": key],
                                      encoding: URLEncoding.default)
        }
    }
}
