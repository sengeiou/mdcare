//
//  LikeModel.swift
//  Medicare
//
//  Created by Thuan on 3/30/20.
//

import Foundation
import ObjectMapper

final class LikeModel: BaseModel {

    // MARK: - Properties

    var good: Int?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.good <- (map["good"], IntTransform())
    }
}
