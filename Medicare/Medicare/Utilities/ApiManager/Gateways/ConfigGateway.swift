//
//  ConfigGateway.swift
//  Medicare
//
//  Created by Thuan on 4/29/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class ConfigGateway: Gateway {

}

extension ConfigGateway {

    func getConfig(type: String, key: String,
                   success: RequestSuccessWithDataClosure? = nil,
                   failure: RequestFailureClosure? = nil) {
        let getRequest = ConfigRequest.getConfig(type, key: key)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse))
        })
    }
}
