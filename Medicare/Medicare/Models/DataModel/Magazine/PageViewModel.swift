//
//  PageViewModel.swift
//  Medicare
//
//  Created by Thuan on 4/4/20.
//

import Foundation
import ObjectMapper

final class PageViewModel: BaseModel {

    // MARK: - Properties

    var pv: Int?
    var grant_point_flg: Int?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.pv <- map["pv"]
        self.grant_point_flg <- map["grant_point_flg"]
    }

    var grantPoint: Bool {
        return (grant_point_flg == 1)
    }
}
