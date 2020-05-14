//
//  MagazineRequest.swift
//  Medicare
//
//  Created by Thuan on 3/24/20.
//

import Foundation
import Moya

enum MagazineRequest {
    case getMagazineList(_ params: [String: Any])
    case getCategoryList
    case like(_ magazineId: Int)
    case favorite(_ params: [String: Any])
    case pageview(_ magazineId: Int)
}

extension MagazineRequest: TargetType {

    var path: String {
        switch self {
        case .getMagazineList:
            return "magazine/list"
        case .getCategoryList:
            return "user/category/list"
        case .like:
            return "magazine/good"
        case .favorite:
            return "magazine/favorite"
        case .pageview:
            return "user/magazine/pageview"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMagazineList:
            return .post
        case .getCategoryList:
            return .post
        case .like:
            return .post
        case .favorite:
            return .post
        case .pageview:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getMagazineList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getCategoryList:
            return .requestPlain
        case .like(let magazineId):
            return .requestParameters(parameters: ["magazine_id": magazineId], encoding: URLEncoding.default)
        case .favorite(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .pageview(let magazineId):
            return .requestParameters(parameters: ["magazine_id": magazineId], encoding: URLEncoding.default)
        }
    }
}
