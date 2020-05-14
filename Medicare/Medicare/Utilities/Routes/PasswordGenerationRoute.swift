//
//  PasswordGenerationRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol PasswordGenerationRoute {
    var openPasswordGenerationTransition: Transition { get }
    func openPasswordGeneration()
}

extension PasswordGenerationRoute where Self: RouterProtocol {

    var openPasswordGenerationTransition: Transition {
        return PushTransition()
    }

    func openPasswordGeneration() {
        let router = PasswordGenerationRouter()
        let passwordGenerationViewController = PasswordGenerationViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = passwordGenerationViewController

        let transition = openPasswordGenerationTransition
        router.openTransition = transition
        open(passwordGenerationViewController, transition: transition)
    }
}
