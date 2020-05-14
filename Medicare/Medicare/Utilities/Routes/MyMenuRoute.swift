//
//  MyMenuRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol MyMenuRoute {
    var openMyMenuTransition: Transition { get }
    func openMyMenu()
}

extension MyMenuRoute where Self: RouterProtocol {

    var openMyMenuTransition: Transition {
        return PushTransition()
    }

    func openMyMenu() {
        let router = MyMenuRouter()
        let myMenuViewController = MyMenuViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = myMenuViewController

        let transition = openMyMenuTransition
        router.openTransition = transition
        open(myMenuViewController, transition: transition)
    }
}
