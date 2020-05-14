//
//  BaseModel.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import ObjectMapper

struct BaseModelKey {
    static let id       = "id"
}

class BaseModel: NSObject, Mappable {

    // MARK: - Properties

    var id: Int = 0

    override init() {
        super.init()
    }

    // MARK: - Properties

    // MARK: - Mappable

    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }

    func mapping(map: ObjectMapper.Map) {
        self.id <- (map[BaseModelKey.id], IntTransform())
    }
}
