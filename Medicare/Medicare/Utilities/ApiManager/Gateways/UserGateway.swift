//
//  UserGateway.swift
//  Medicare
//
//  Created by Thuan on 3/25/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class UserGateway: Gateway {

}

extension UserGateway {

    func signin(_ params: [String: Any],
                success: RequestSuccessWithDataClosure? = nil,
                failure: RequestFailureClosure? = nil) {
        let getRequest = UserRequest.signin(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse, isAutoAlert: false))
        })
    }

    func signup(_ params: [String: Any],
                success: RequestSuccessWithDataClosure? = nil,
                failure: RequestFailureClosure? = nil) {
        let getRequest = UserRequest.signup(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse, isAutoAlert: false))
        })
    }

    func otpValidate(_ params: [String: Any],
                     success: RequestSuccessWithDataClosure? = nil,
                     failure: RequestFailureClosure? = nil) {
        let getRequest = UserRequest.otpValidate(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse, isAutoAlert: false))
        })
    }

    func settingNotification(_ setting: Int,
                             success: RequestSuccessWithDataClosure? = nil,
                             failure: RequestFailureClosure? = nil) {
        let getRequest = UserRequest.settingNotification(setting)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse, isAutoAlert: false))
        })
    }

    func pointGrant(_ params: [String: Any],
                    success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = UserRequest.pointGrant(params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }

    func unregister(success: RequestSuccessWithDataClosure? = nil) {
        let getRequest = UserRequest.unregister
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            _ = DefaultRequestFailureHandler(errorResponse)
        })
    }
}
