//
//  HomeGateway.swift
//  Medicare
//
//  Created by Thuan on 3/23/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class HomeGateway: Gateway {

}

extension HomeGateway {

    func getTopData(success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = HomeRequest.getTopData
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }
}
