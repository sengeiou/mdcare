//
//  ZipcodeGateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation

struct ZipcodeGateway {

    func search(zipcode: String,
                success: RequestSuccessWithDataClosure? = nil,
                failure: RequestFailureClosure? = nil) {
        let request = ZipcodeRequest.search(zipcode: zipcode)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }
}
