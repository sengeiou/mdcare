//
//  GiftGateway.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class GiftGateway: Gateway {

}

extension GiftGateway {

    func getPresentList(pageSize: Int, pageIndex: Int,
                        success: RequestSuccessWithDataClosure? = nil,
                        failure: RequestFailureClosure? = nil) {
        let getRequest = GiftRequest.getPresentList(pageSize, pageIndex: pageIndex)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse))
        })
    }

    func getPresentDetail(_ presentId: Int, success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = GiftRequest.getPresentDetail(presentId)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }
}
