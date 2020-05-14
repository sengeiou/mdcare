//
//  PresentApplicationDoneRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol PresentApplicationDoneRoute {
    var openPresentApplicationDoneTransition: Transition { get }
    func openPresentApplicationDone()
}

extension PresentApplicationDoneRoute where Self: RouterProtocol {

    var openPresentApplicationDoneTransition: Transition {
        return PushTransition()
    }

    func openPresentApplicationDone() {
        let router = PresentApplicationDoneRouter()
        let presentApplicationDoneViewController = PresentApplicationDoneViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = presentApplicationDoneViewController

        let transition = openPresentApplicationDoneTransition
        router.openTransition = transition
        open(presentApplicationDoneViewController, transition: transition)
    }
}
