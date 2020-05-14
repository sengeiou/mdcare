//
//  SMSAuthenticationRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol OTPAuthenticationRoute {
    func openOTPAuthenticationView(isRegisterNew: Bool, request: UserAuthenticationModel)
}

extension OTPAuthenticationRoute where Self: RouterProtocol {

    func openOTPAuthenticationView(isRegisterNew: Bool, request: UserAuthenticationModel) {
        let router = OTPAuthenticationRouter()
        let otpAuthenView = OTPAuthenticationViewController.newInstance().then {
            $0.route = router
            $0.isRegisterNew = isRegisterNew
            $0.request = request
        }
        router.viewController = otpAuthenView

        let trans = PushTransition()
        router.openTransition = trans
        open(otpAuthenView, transition: trans)
    }
}
