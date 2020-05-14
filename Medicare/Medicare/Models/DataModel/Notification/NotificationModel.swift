//
//  NotificationModel.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation
import ObjectMapper

final class NotificationModel: BaseModel {

    // MARK: - Properties

    var title: String?
    var content: String?
    var user_type: String?
    var user_permit: String?
    var start_at: String?
    var end_at: String?
    var status: String?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.title          <- map["title"]
        self.content        <- map["content"]
        self.user_type      <- map["user_type"]
        self.user_permit    <- map["user_permit"]
        self.start_at       <- map["start_at"]
        self.end_at         <- map["end_at"]
        self.status         <- map["status"]
        self.created_at     <- map["created_at"]
        self.updated_at     <- map["updated_at"]
        self.deleted_at     <- map["deleted_at"]
    }

    var time: String {
        if let timeStr = start_at,
            let date = yyyyMMddHHmmssWithDashDateColonTimeFormatter.date(from: timeStr) {
            return yyyyMMddWithDotFormatter.string(from: date)
        }
        return ""
    }
}
