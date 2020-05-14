//
//  ChangeUserInfoOptionRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol ChangeUserInfoOptionRoute {
    var openChangeUserInfoOptionTransition: Transition { get }
    func openChangeUserInfoOption()
}

extension ChangeUserInfoOptionRoute where Self: RouterProtocol {

    var openChangeUserInfoOptionTransition: Transition {
        return PushTransition()
    }

    func openChangeUserInfoOption() {
        let router = ChangeUserInfoOptionRouter()
        let changeUserInfoOptionViewController = ChangeUserInfoOptionViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = changeUserInfoOptionViewController

        let transition = openChangeUserInfoOptionTransition
        router.openTransition = transition
        open(changeUserInfoOptionViewController, transition: transition)
    }
}
