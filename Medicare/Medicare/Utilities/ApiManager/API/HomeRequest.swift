//
//  HomeRequest.swift
//  Medicare
//
//  Created by Thuan on 3/23/20.
//

import Foundation
import Moya

enum HomeRequest {
    case getTopData
}

extension HomeRequest: TargetType {

    var path: String {
        switch self {
        case .getTopData:
            return "top"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getTopData:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getTopData:
            return .requestPlain
        }
    }
}
