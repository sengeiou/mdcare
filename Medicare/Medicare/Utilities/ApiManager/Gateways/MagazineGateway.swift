//
//  MagazineGateway.swift
//  Medicare
//
//  Created by Thuan on 3/24/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class MagazineGateway: Gateway {

}

extension MagazineGateway {

    func getMagazineList(_ params: [String: Any],
                         success: RequestSuccessWithDataClosure? = nil,
                         failure: RequestFailureClosure? = nil) {
        let getRequest = MagazineRequest.getMagazineList(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse))
        })
    }

    func getCategoryList(success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = MagazineRequest.getCategoryList
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func like(_ magazineId: Int, success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = MagazineRequest.like(magazineId)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func favorite(_ params: [String: Any], success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = MagazineRequest.favorite(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func pageView(_ magazineId: Int, success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = MagazineRequest.pageview(magazineId)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }
}
