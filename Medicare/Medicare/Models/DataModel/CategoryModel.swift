//
//  CategoryModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct CategoryModelKey {
    static let id       = "id"
    static let name     = "name"
    static let img_path = "img_path"
    static let selected = "selected"
    static let media    = "media"
}

final class CategoryModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var name         : String          = TSConstants.EMPTY_STRING
    var img_path     : URL?
    var selected     : Bool            = false
    var wellnessType : WellnessType    = .none
    var media        : [MediaProtocol] = []
    // swiftlint:enable colon

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        let urlTransform = URLTransform(shouldEncodeURLString: true,
                                        allowedCharacterSet: .urlPathAllowed)
        self.name     <- map[CategoryModelKey.name]
        self.img_path <- (map[CategoryModelKey.img_path], urlTransform)
        self.selected <- (map[CategoryModelKey.selected], BoolTransform())
        self.media    <- map[CategoryModelKey.media]
    }
}
