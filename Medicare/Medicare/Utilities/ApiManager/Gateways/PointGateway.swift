//
//  PointGateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation

struct PointGateway {

    func getPointHistory(success: RequestSuccessWithDataClosure? = nil,
                         failure: RequestFailureClosure? = nil) {
        let request = PointRequest.pointHistory
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }

    func redeemPoint(info: [String: Any],
                     success: RequestSuccessWithDataClosure? = nil,
                     failure: RequestFailureClosure? = nil) {
        let request = PointRequest.pointRedeem(info: info)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }

    func earnPoint(info: [String: Any],
                   success: RequestSuccessWithDataClosure? = nil,
                   failure: RequestFailureClosure? = nil) {
        let request = PointRequest.pointEarn(info: info)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }
}
