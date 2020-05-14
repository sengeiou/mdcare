//
//  ErrorModel.swift
//  Medicare
//
//  Created by Thuan on 3/26/20.
//

import Foundation
import ObjectMapper

final class ErrorModel: BaseModel {

    // MARK: - Properties

    var code: Int?
    var message: String?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.code <- map["code"]
        self.message <- map["message"]
    }
}
