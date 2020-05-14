//
//  DetailGiftRoute.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

protocol NotificationSettingRoute {
    func openSettingView()
}

extension NotificationSettingRoute where Self: RouterProtocol {

    func openSettingView() {
        let router = NotificationSettingRouter()
        let settingViewController = NotificationSettingViewController.newInstance().then {
            $0.route = router
        }
        router.viewController = settingViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(settingViewController, transition: trans)
    }
}
