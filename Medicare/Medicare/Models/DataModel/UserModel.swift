//
//  UserModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct UserModelKey {
    static let id          = "id"
    static let type        = "type"
    static let name        = "name"
    static let status      = "status"
    static let last_login  = "last_login"
    static let login_hash  = "login_hash"
    static let resigned_at = "resigned_at"
    static let created_at  = "created_at"
    static let updated_at  = "updated_at"
    static let deleted_at  = "deleted_at"
    static let user_detail = "user_detail"
}

final class UserModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var type        : Int             = 0
    var name        : String          = TSConstants.EMPTY_STRING
    var status      : String          = TSConstants.EMPTY_STRING
    var last_login  : String          = TSConstants.EMPTY_STRING
    var login_hash  : String          = TSConstants.EMPTY_STRING
    var resigned_at : String          = TSConstants.EMPTY_STRING
    var created_at  : String          = TSConstants.EMPTY_STRING
    var updated_at  : String          = TSConstants.EMPTY_STRING
    var deleted_at  : String          = TSConstants.EMPTY_STRING
    var user_detail : UserDetailModel = UserDetailModel()
    // swiftlint:enable colon

    var isRegisteredInfo: Bool {
        return type == 2 // 1: Unregistered, 2: Registered
    }

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.type        <- (map[UserModelKey.type], IntTransform())
        self.name        <- map[UserModelKey.name]
        self.status      <- map[UserModelKey.status]
        self.last_login  <- map[UserModelKey.last_login]
        self.login_hash  <- map[UserModelKey.login_hash]
        self.resigned_at <- map[UserModelKey.resigned_at]
        self.created_at  <- map[UserModelKey.created_at]
        self.updated_at  <- map[UserModelKey.updated_at]
        self.deleted_at  <- map[UserModelKey.deleted_at]
        self.user_detail <- map[UserModelKey.user_detail]
    }
}
