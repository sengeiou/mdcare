//
//  CategoryGateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation

struct CategoryGateway {

    func getCategoryList(success: RequestSuccessWithDataClosure? = nil,
                         failure: RequestFailureClosure? = nil) {
        let request = CategoryRequest.categoryList
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }

    func updateCategory(ids: [Int],
                        success: RequestSuccessWithDataClosure? = nil,
                        failure: RequestFailureClosure? = nil) {
        let request = CategoryRequest.updateCategory(ids: ids)
        TSApiManager.shared.request(api: request, nextHandler: { (response) in
            success?(response)
        }, errorHandle: { (errorResponse) in
            let message = DefaultRequestFailureHandler(errorResponse)

            failure?(message)
        })
    }
}
