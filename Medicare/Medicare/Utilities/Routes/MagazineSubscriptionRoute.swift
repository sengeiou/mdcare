//
//  MagazineSubscriptionRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol MagazineSubscriptionRoute {
    var openMagazineSubscriptionTransition: Transition { get }
    func openMagazineSubscription()
}

extension MagazineSubscriptionRoute where Self: RouterProtocol {

    var openMagazineSubscriptionTransition: Transition {
        return PushTransition()
    }

    func openMagazineSubscription() {
        let router = MagazineSubscriptionRouter()
        let magazineSubscriptionViewController = MagazineSubscriptionViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = magazineSubscriptionViewController

        let transition = openMagazineSubscriptionTransition
        router.openTransition = transition
        open(magazineSubscriptionViewController, transition: transition)
    }
}
