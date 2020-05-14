//
//  NotificationRequest.swift
//  Medicare
//
//  Created by Thuan on 3/23/20.
//

import Foundation
import Moya

enum NotificationRequest {
    case getNotificationList(_ pageSize: Int, pageIndex: Int)
}

extension NotificationRequest: TargetType {

    var path: String {
        switch self {
        case .getNotificationList:
            return "information/list"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getNotificationList:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getNotificationList(let pageSize, let pageIndex):
            return .requestParameters(parameters: ["page_size": pageSize, "page_index": pageIndex],
                                      encoding: URLEncoding.default)
        }
    }
}
