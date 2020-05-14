//
//  DetailGiftRouter.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

final class DetailGiftRouter: Router<DetailGiftViewController>, DetailGiftRouter.Routes {
    typealias Routes = PresentApplicationRoute
        & PresentApplicationDoneRoute
}
