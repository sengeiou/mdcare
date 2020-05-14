//
//  VideoGateway.swift
//  Medicare
//
//  Created by Thuan on 3/27/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class VideoGateway: Gateway {

}

extension VideoGateway {

    func getMovieList(_ params: [String: Any],
                      success: RequestSuccessWithDataClosure? = nil,
                      failure: RequestFailureClosure? = nil) {
        let getRequest = VideoRequest.getMovieList(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse))
        })
    }

    func like(_ movieId: Int, success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = VideoRequest.like(movieId)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func favorite(_ params: [String: Any], success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = VideoRequest.favorite(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func getChannelList(success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = VideoRequest.getChannelList
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func pageView(_ movieId: Int, success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = VideoRequest.pageview(movieId)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }
}
