//
//  WellnessRequest.swift
//  Medicare
//
//  Created by sanghv on 4/27/19.
//

import Foundation
import Moya

enum WellnessRequest {
    case wellessList
}

extension WellnessRequest: TargetType {

    var path: String {
        switch self {
        case .wellessList:
            return "/wellness/list"
        }
    }

    var method: Moya.Method {
        switch self {
        case .wellessList:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .wellessList:
            return .requestPlain
        }
    }
}
