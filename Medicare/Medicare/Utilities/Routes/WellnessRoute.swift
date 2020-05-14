//
//  WellnessRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol WellnessRoute {
    var openWellnessTransition: Transition { get }
    func openWellness()
}

extension WellnessRoute where Self: RouterProtocol {

    var openWellnessTransition: Transition {
        return PushTransition()
    }

    func openWellness() {
        let router = WellnessRouter()
        let wellnessViewController = WellnessViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = wellnessViewController

        let transition = openWellnessTransition
        router.openTransition = transition
        open(wellnessViewController, transition: transition)
    }
}
