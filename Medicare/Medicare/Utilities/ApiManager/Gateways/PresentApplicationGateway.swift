//
//  PresentApplicationGateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation

struct PresentApplicationGateway {

    func getQuestionOf(presentId: Int,
                       success: RequestSuccessWithDataClosure? = nil,
                       failure: RequestFailureClosure? = nil) {
        let request = PresentApplicationRequest.question(presentId: presentId)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }

    func applicant(presentId: Int,
                   data: [String: Any],
                   success: RequestSuccessWithDataClosure? = nil,
                   failure: RequestFailureClosure? = nil) {
        let request = PresentApplicationRequest.applicant(presentId: presentId, data: data)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }
}
