//
//  SMSAuthenticationRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol SMSAuthenticationRoute {
    func openAuthenticationView(isRegisterNew: Bool)
}

extension SMSAuthenticationRoute where Self: RouterProtocol {

    func openAuthenticationView(isRegisterNew: Bool) {
        let router = SMSAuthenticationRouter()
        let newRegistrationViewController = SMSAuthenticationViewController.newInstance().then {
            $0.route = router
            $0.isRegisterNew = isRegisterNew
        }
        router.viewController = newRegistrationViewController

        let trans = PushTransition()
        router.openTransition = trans
        open(newRegistrationViewController, transition: trans)
    }
}
