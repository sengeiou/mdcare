//
//  HomeViewRouter.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

final class HomeViewRouter: Router<HomeViewController>, HomeViewRouter.Routes {
    typealias Routes = NotificationListRoute
        & DetailNotificationRoute
        & DetailVideoRoute
        & DetailGiftRoute
        & DetailMagazineRoute
}
