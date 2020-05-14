//
//  GiftSupplementaryModel.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import ObjectMapper

final class GiftSupplementaryModel: BaseModel {

    // MARK: - Properties

    var img_path: URL?
    var desc: String?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.img_path <- (map["img_path"], URLTransform())
        self.desc <- map["description"]
    }

    var imageNull: Bool {
        return img_path == nil
    }

    var contentNull: Bool {
        return (desc == nil || desc == "")
    }
}
