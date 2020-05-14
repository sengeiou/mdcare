//
//  ErrorResultModel.swift
//  Medicare
//
//  Created by Thuan on 3/26/20.
//

import Foundation
import ObjectMapper

final class ErrorResultModel: BaseModel {

    // MARK: - Properties

    var result: Bool?
    var errors: [ErrorModel]?
    var data: ConfigDataModel?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.result <- map["result"]
        self.errors <- map["errors"]
        self.data <- map["data"]
    }
}
