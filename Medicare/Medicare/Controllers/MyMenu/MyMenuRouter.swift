//
//  MyMenuRouter.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

final class MyMenuRouter: Router<MyMenuViewController>, MyMenuRouter.Routes {
    typealias Routes = PointRoute
        & ChangeUserInfoOptionRoute
        & DataTransferRoute
        & TermsRoute
        & NotificationSettingRoute
        & QRScannerRoute
        & NotificationListRoute
        & DetailNotificationRoute
        & UnregisterRoute
}
