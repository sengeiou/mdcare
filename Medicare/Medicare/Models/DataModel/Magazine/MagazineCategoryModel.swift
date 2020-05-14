//
//  MagazineCategoryModel.swift
//  Medicare
//
//  Created by Thuan on 3/23/20.
//

import Foundation
import ObjectMapper

final class MagazineCategoryModel: BaseModel {

    // MARK: - Properties

    var name: String?
    var selected: Int?

    var isSelected = false
    var type: MagazineTabIndex = .other

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.name <- map["name"]
        self.selected <- (map["selected"], IntTransform())
    }

    var magazineSelected: Bool {
        return selected == 1
    }
}
