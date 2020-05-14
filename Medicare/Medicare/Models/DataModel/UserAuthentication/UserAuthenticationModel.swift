//
//  UserAuthenticationModel.swift
//  Medicare
//
//  Created by Thuan on 3/27/20.
//

import Foundation
import ObjectMapper

final class UserAuthenticationModel: BaseModel {

    // MARK: - Properties

    var request_id: String?
    var tel_no: String?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.request_id <- map["request_id"]
    }
}
