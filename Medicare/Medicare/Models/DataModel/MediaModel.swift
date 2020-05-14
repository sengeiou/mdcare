//
//  MediaModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct MediaModelKey {
    static let id       = "id"
    static let name     = "name"
    static let imageUrl = "imageUrl"
    static let url      = "url"
}

final class MediaModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var name     : String = TSConstants.EMPTY_STRING
    var imageUrl : URL?
    var url      : URL?
    // swiftlint:enable colon

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.name     <- map[MediaModelKey.name]
        self.imageUrl <- (map[MediaModelKey.imageUrl], URLTransform())
        self.url      <- (map[MediaModelKey.url], URLTransform())
    }
}
