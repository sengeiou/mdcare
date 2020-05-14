//
//  AuthenticationRequest.swift
//  Medicare
//
//  Created by sanghv on 4/27/19.
//

import Foundation
import Moya

enum AuthenticationRequest {
    case userInfo
    case userUpdate(info: [String: Any])
}

extension AuthenticationRequest: TargetType {

    var path: String {
        switch self {
        case .userInfo:
            return "/user/info"
        case .userUpdate:
            return "/user/update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .userInfo:
            return .post
        case .userUpdate:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .userInfo:
            return .requestPlain
        case .userUpdate(let info):
            let params = info
            let task = multipartTaskFrom(params)

            return task
        }
    }
}
