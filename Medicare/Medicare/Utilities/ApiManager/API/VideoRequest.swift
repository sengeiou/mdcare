//
//  VideoRequest.swift
//  Medicare
//
//  Created by Thuan on 3/27/20.
//

import Foundation
import Moya

enum VideoRequest {
    case getMovieList(_ params: [String: Any])
    case like(_ movieId: Int)
    case favorite(_ params: [String: Any])
    case getChannelList
    case pageview(_ movieId: Int)
}

extension VideoRequest: TargetType {

    var path: String {
        switch self {
        case .getMovieList:
            return "movie/list"
        case .like:
            return "movie/good"
        case .favorite:
            return "movie/favorite"
        case .getChannelList:
            return "channel/list"
        case .pageview:
            return "user/movie/pageview"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMovieList:
            return .post
        case .like:
            return .post
        case .favorite:
            return .post
        case .getChannelList:
            return .post
        case .pageview:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getMovieList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .like(let movieId):
            return .requestParameters(parameters: ["movie_id": movieId], encoding: URLEncoding.default)
        case .favorite(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getChannelList:
            return .requestPlain
        case .pageview(let movieId):
            return .requestParameters(parameters: ["movie_id": movieId], encoding: URLEncoding.default)
        }
    }
}
