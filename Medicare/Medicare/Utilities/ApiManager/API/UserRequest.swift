//
//  UserRequest.swift
//  Medicare
//
//  Created by Thuan on 3/25/20.
//

import Foundation
import Moya

enum UserRequest {
    case signup(_ params: [String: Any])
    case signin(_ params: [String: Any])
    case otpValidate(_ params: [String: Any])
    case settingNotification(_ setting: Int)
    case pointGrant(_ params: [String: Any])
    case unregister
}

extension UserRequest: TargetType {

    var path: String {
        switch self {
        case .signup:
            return "sms/request_signup"
        case .signin:
            return "sms/request_signin"
        case .otpValidate:
            return "sms/validate"
        case .settingNotification:
            return "user/setting/notification"
        case .pointGrant:
            return "user/point/grant"
        case .unregister:
            return "user/unregister"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        case .signin:
            return .post
        case .otpValidate:
            return .post
        case .settingNotification:
            return .post
        case .pointGrant:
            return .post
        case .unregister:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .signup(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .signin(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .otpValidate(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .settingNotification(let setting):
            return .requestParameters(parameters: ["notification_setting": setting], encoding: URLEncoding.default)
        case .pointGrant(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .unregister:
            return .requestPlain
        }
    }
}
