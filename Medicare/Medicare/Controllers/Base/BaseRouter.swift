//
//  BaseRouter.swift
//  Medicare
//
//  Created by sanghv on 1/4/20.
//

import Foundation

final class BaseRouter: Router<BaseViewController>, BaseRouter.Routes {
    typealias Routes = MyMenuRoute
        & NotificationListRoute
}
