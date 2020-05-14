//
//  RecoverAccountRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol RecoverAccountRoute {
    func openRecoverView()
}

extension RecoverAccountRoute where Self: RouterProtocol {

    func openRecoverView() {
        let router = RecoverAccountRouter()
        let recoverViewController = RecoverAccountViewController.newInstance().then {
            $0.route = router
        }
        router.viewController = recoverViewController

        let trans = PushTransition()
        router.openTransition = trans
        open(recoverViewController, transition: trans)
    }
}
