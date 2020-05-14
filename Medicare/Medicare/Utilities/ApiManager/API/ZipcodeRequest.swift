//
//  ZipcodeRequest.swift
//  Medicare
//
//  Created by sanghv on 4/27/19.
//

import Foundation
import Moya

enum ZipcodeRequest {
    case search(zipcode: String)
}

extension ZipcodeRequest: TargetType {

    var path: String {
        switch self {
        case .search:
            return "/user/setting/zipcode"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .search(let zipcode):
            let params = [
                "zipcode": zipcode
            ]
            let task = multipartTaskFrom(params)

            return task
        }
    }
}
