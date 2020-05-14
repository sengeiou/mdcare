//
//  CategoryRequest.swift
//  Medicare
//
//  Created by sanghv on 4/27/19.
//

import Foundation
import Moya

enum CategoryRequest {
    case categoryList
    case updateCategory(ids: [Int])
}

extension CategoryRequest: TargetType {

    var path: String {
        switch self {
        case .categoryList:
            return "/user/category/list"
        case .updateCategory:
            return "/category/update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .categoryList:
            return .post
        case .updateCategory:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .categoryList:
            return .requestPlain
        case .updateCategory(let ids):
            let ids = Array(Set(ids)).sorted { $0 < $1 }
            var params: [String: Any] = [:]
            params["category_selected_ids[\(0)]"] = ""
            for (index, id) in ids.enumerated() {
                params["category_selected_ids[\(index)]"] = id
            }
            let task = multipartTaskFrom(params)

            return task
        }
    }
}
