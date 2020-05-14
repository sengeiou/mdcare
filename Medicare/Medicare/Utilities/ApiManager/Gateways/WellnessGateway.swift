//
//  WellnessGateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation

struct WellnessGateway {

    func getWellness(success: RequestSuccessWithDataClosure? = nil,
                     failure: RequestFailureClosure? = nil) {
        let request = WellnessRequest.wellessList
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }
}
