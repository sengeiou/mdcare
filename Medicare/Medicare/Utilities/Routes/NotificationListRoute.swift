//
//  NotificationListRoute.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

protocol NotificationListRoute {
    func openNotificationListView()
}

extension NotificationListRoute where Self: RouterProtocol {

    func openNotificationListView() {
        let router = NotificationListRouter()
        let listViewController = NotificationListViewController.newInstance().then {
            $0.route = router
        }
        router.viewController = listViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(listViewController, transition: trans)
    }
}
