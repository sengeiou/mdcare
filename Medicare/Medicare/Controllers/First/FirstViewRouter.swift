//
//  FirstViewRouter.swift
//  Medicare
//
//  Created by Thuan on 3/3/20.
//

import Foundation

final class FirstViewRouter: Router<FirstViewController>, FirstViewRouter.Routes {
    typealias Routes = SMSAuthenticationRoute
            & RecoverAccountRoute
            & TermsRoute
}
