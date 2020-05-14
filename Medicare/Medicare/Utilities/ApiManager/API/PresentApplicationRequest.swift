//
//  PresentApplicationRequest.swift
//  Medicare
//
//  Created by sanghv on 4/27/19.
//

import Foundation
import Moya

enum PresentApplicationRequest {
    case question(presentId: Int)
    case applicant(presentId: Int, data: [String: Any])
}

extension PresentApplicationRequest: TargetType {

    var path: String {
        switch self {
        case .question:
            return "/present/question"
        case .applicant:
            return "/present/applicant"
        }
    }

    var method: Moya.Method {
        switch self {
        case .question:
            return .post
        case .applicant:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .question(let presentId):
            let params: [String: Any] = [
                "present_id": presentId
            ]
            let task = multipartTaskFrom(params)

            return task
        case .applicant(let presentId, let data):
            var params = data
            params["present_id"] = presentId
            let task = multipartTaskFrom(params)

            return task
        }
    }
}
