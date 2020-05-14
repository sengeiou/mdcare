//
//  ChangePersonalInfoSummaryRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol ChangePersonalInfoSummaryRoute {
    var openChangePersonalInfoSummaryTransition: Transition { get }
    func openChangePersonalInfoSummary(userDetail: UserDetailModel, updateMagazineSubscription: Bool)
}

extension ChangePersonalInfoSummaryRoute where Self: RouterProtocol {

    var openChangePersonalInfoSummaryTransition: Transition {
        return PushTransition()
    }

    func openChangePersonalInfoSummary(userDetail: UserDetailModel, updateMagazineSubscription: Bool) {
        let router = ChangePersonalInfoSummaryRouter()
        let changePersonalInfoSummaryViewController = ChangePersonalInfoSummaryViewController.newInstance().then {
            $0.set(router: router)
            $0.set(userDetail: userDetail)
            $0.updateMagazineSubscription = updateMagazineSubscription
        }
        router.viewController = changePersonalInfoSummaryViewController

        let transition = openChangePersonalInfoSummaryTransition
        router.openTransition = transition
        open(changePersonalInfoSummaryViewController, transition: transition)
    }
}
