//
//  PointRequest.swift
//  Medicare
//
//  Created by sanghv on 4/27/19.
//

import Foundation
import Moya

enum PointRequest {
    case pointHistory
    case pointRedeem(info: [String: Any])
    case pointEarn(info: [String: Any])
}

extension PointRequest: TargetType {

    var path: String {
        switch self {
        case .pointHistory:
            return "/user/point/history"
        case .pointRedeem:
            return "/user/point/redeem"
        case .pointEarn:
            return "/user/point/grant"
        }
    }

    var method: Moya.Method {
        switch self {
        case .pointHistory:
            return .post
        case .pointRedeem:
            return .post
        case .pointEarn:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .pointHistory:
            return .requestPlain
        case .pointRedeem(let info), .pointEarn(let info):
            let params = info
            let task = multipartTaskFrom(params)

            return task
        }
    }
}
