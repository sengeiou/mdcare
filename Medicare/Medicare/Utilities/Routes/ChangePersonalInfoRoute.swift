//
//  ChangePersonalInfoRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol ChangePersonalInfoRoute {
    var openChangePersonalInfoTransition: Transition { get }
    func openChangePersonalInfo()
}

extension ChangePersonalInfoRoute where Self: RouterProtocol {

    var openChangePersonalInfoTransition: Transition {
        return PushTransition()
    }

    func openChangePersonalInfo() {
        let router = ChangePersonalInfoRouter()
        let changePersonalInfoViewController = ChangePersonalInfoViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = changePersonalInfoViewController

        let transition = openChangePersonalInfoTransition
        router.openTransition = transition
        open(changePersonalInfoViewController, transition: transition)
    }
}
