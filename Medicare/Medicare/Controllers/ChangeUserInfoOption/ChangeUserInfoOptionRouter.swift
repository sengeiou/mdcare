//
//  ChangeUserInfoOptionRouter.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

final class ChangeUserInfoOptionRouter: Router<ChangeUserInfoOptionViewController>, ChangeUserInfoOptionRouter.Routes {
    typealias Routes = CategorySettingRoute
        & ChangePersonalInfoRoute
}
