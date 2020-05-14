//
//  GiftGroupModel.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import ObjectMapper

final class GiftGroupModel: BaseModel {

    // MARK: - Properties

    var name: String?
    var presents: [GiftModel]?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.name <- map["name"]
        self.presents <- map["presents"]
    }
}
