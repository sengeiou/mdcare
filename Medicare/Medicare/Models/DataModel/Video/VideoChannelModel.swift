//
//  VideoChannelModel.swift
//  Medicare
//
//  Created by Thuan on 3/18/20.
//

import Foundation
import ObjectMapper

final class VideoChannelModel: BaseModel {

    // MARK: - Properties

    var title: String?
    var desc: String?
    var status: Int?
    var img_path: URL?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.title <- map["title"]
        self.desc <- map["description"]
        self.status <- (map["status"], IntTransform())
        self.img_path <- (map["img_path"], URLTransform())
        self.created_at <- map["created_at"]
        self.updated_at <- map["updated_at"]
        self.deleted_at <- map["deleted_at"]
    }
}
