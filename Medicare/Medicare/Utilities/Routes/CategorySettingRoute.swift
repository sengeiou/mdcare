//
//  CategorySettingRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol CategorySettingRoute {
    var openCategorySettingTransition: Transition { get }
    func openCategorySetting(isRegistration: Bool, isHiddenBack: Bool)
}

extension CategorySettingRoute where Self: RouterProtocol {

    var openCategorySettingTransition: Transition {
        return PushTransition()
    }

    func openCategorySetting(isRegistration: Bool, isHiddenBack: Bool) {
        let router = CategorySettingRouter()
        let categorySettingViewController = CategorySettingViewController.newInstance().then {
            $0.set(router: router)
            $0.isRegistration = isRegistration
            $0.isHiddenBack = isHiddenBack
        }
        router.viewController = categorySettingViewController

        let transition = openCategorySettingTransition
        router.openTransition = transition
        open(categorySettingViewController, transition: transition)
    }
}
