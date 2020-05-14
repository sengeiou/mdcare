//
//  PointRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol PointRoute {
    var openPointTransition: Transition { get }
    func openPointBalance()
}

extension PointRoute where Self: RouterProtocol {

    var openPointTransition: Transition {
        return PushTransition()
    }

    func openPointBalance() {
        let router = PointRouter()
        let pointViewController = PointViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = pointViewController

        let transition = openPointTransition
        router.openTransition = transition
        open(pointViewController, transition: transition)
    }
}
