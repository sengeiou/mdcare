//
//  DetailNotificationRoute.swift
//  Medicare
//
//  Created by Thuan on 3/10/20.
//

import Foundation

protocol DetailNotificationRoute {
    func openNotificationDetailView(_ information: NotificationModel)
}

extension DetailNotificationRoute where Self: RouterProtocol {

    func openNotificationDetailView(_ information: NotificationModel) {
        let router = DetailNotificationRouter()
        let detailViewController = DetailNotificationViewController.newInstance().then {
            $0.route = router
            $0.information = information
        }
        router.viewController = detailViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(detailViewController, transition: trans)
    }
}
