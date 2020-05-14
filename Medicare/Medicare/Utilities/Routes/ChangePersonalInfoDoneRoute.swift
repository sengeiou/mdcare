//
//  ChangePersonalInfoDoneRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol ChangePersonalInfoDoneRoute {
    var openChangePersonalInfoDoneTransition: Transition { get }
    func openChangePersonalInfoDone()
}

extension ChangePersonalInfoDoneRoute where Self: RouterProtocol {

    var openChangePersonalInfoDoneTransition: Transition {
        return PushTransition()
    }

    func openChangePersonalInfoDone() {
        let router = ChangePersonalInfoDoneRouter()
        let changePersonalInfoDoneViewController = ChangePersonalInfoDoneViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = changePersonalInfoDoneViewController

        let transition = openChangePersonalInfoDoneTransition
        router.openTransition = transition
        open(changePersonalInfoDoneViewController, transition: transition)
    }
}
