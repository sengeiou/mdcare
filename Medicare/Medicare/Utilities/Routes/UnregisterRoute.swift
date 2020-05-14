//
//  UnregisterRoute.swift
//  Medicare
//
//  Created by Thuan on 4/16/20.
//

import Foundation

protocol UnregisterRoute {
    func openUnregisterView()
}

extension UnregisterRoute where Self: RouterProtocol {

    func openUnregisterView() {
        let router = UnregisterRouter()
        let unregisterViewController = UnregisterViewController.newInstance().then {
            $0.router = router
        }
        router.viewController = unregisterViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(unregisterViewController, transition: trans)
    }
}
