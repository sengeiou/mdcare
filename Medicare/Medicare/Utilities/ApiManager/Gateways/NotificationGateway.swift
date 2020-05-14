//
//  NotificationGateway.swift
//  Medicare
//
//  Created by Thuan on 3/23/20.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NotificationGateway: Gateway {

}

extension NotificationGateway {

    func getNotificationList(pageSize: Int, pageIndex: Int,
                             success: RequestSuccessWithDataClosure? = nil,
                             failure: RequestFailureClosure? = nil) {
        let getRequest = NotificationRequest.getNotificationList(pageSize, pageIndex: pageIndex)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }, errorHandle: { (errorResponse) in
            failure?(DefaultRequestFailureHandler(errorResponse))
        })
    }
}
