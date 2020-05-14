//
//  VideoCategoryModel.swift
//  Medicare
//
//  Created by Thuan on 3/24/20.
//

import Foundation
import ObjectMapper

final class VideoCategoryModel: BaseModel {

    // MARK: - Properties

    var name: String?

    var isSelected = false
    var type: VideoTabIndex = .none

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.name <- map["name"]
    }
}
