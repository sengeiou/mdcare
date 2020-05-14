//
//  AuthenticationGateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation

struct AuthenticationGateway {

    func updateUser(info: [String: Any],
                    success: RequestSuccessWithDataClosure? = nil,
                    failure: RequestFailureClosure? = nil) {
        let request = AuthenticationRequest.userUpdate(info: info)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }

    func getUserInfo(success: RequestSuccessWithDataClosure? = nil,
                     failure: RequestFailureClosure? = nil) {
        let request = AuthenticationRequest.userInfo
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }
}
