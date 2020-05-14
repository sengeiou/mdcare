//
//  StartupRouter.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

final class StartupRouter: Router<StartupViewController>, StartupRouter.Routes {
    typealias Routes = CategorySettingRoute
        & MagazineSubscriptionRoute
        & PointRoute
        & MyMenuRoute
        & DataTransferRoute
        & PasswordGenerationRoute
        & TermsRoute
        & PresentApplicationRoute
        & WellnessRoute
        & PresentApplicationDoneRoute
}
