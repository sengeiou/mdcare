//
//  GiftRequest.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import Moya

enum GiftRequest {
    case getPresentList(_ pageSize: Int, pageIndex: Int)
    case getPresentDetail(_ presenId: Int)
}

extension GiftRequest: TargetType {

    var path: String {
        switch self {
        case .getPresentList:
            return "present/list"
        case .getPresentDetail:
            return "present/detail"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPresentList:
            return .post
        case .getPresentDetail:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getPresentList(let pageSize, let pageIndex):
            return .requestParameters(parameters: ["page_size": pageSize, "page_index": pageIndex],
                                      encoding: URLEncoding.default)
        case .getPresentDetail(let presentId):
            return .requestParameters(parameters: ["present_id": presentId], encoding: URLEncoding.default)
        }
    }
}
