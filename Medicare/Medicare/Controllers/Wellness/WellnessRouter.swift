//
//  WellnessRouter.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

final class WellnessRouter: Router<WellnessViewController>, WellnessRouter.Routes {
    typealias Routes = DetailMagazineRoute
        & DetailVideoRoute
        & DetailGiftRoute
}
