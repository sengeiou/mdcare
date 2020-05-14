//
//  PointHistoryModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct PointHistoryModelKey {
    static let id        = "id"
    static let type      = "type"
    static let point     = "point"
    static let target_id = "target_id"
    static let gaint_flg = "gaint_flg"
    static let title     = "title"
}

enum PointType: String {
    case none = "-1", spent = "0", earn = "1"
}

final class PointHistoryModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var type      : Int       = 0
    var point     : Int       = 0
    var target_id : Int       = 0
    var gaint_flg : PointType = .none
    var title     : String    = TSConstants.EMPTY_STRING
    // swiftlint:enable colon

    func getConvertedPoint() -> String {
        return groupNumberFormatter.string(for: point) ?? TSConstants.ZERO_STRING
    }

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.type      <- (map[PointHistoryModelKey.type], IntTransform())
        self.point     <- (map[PointHistoryModelKey.point], IntTransform())
        self.target_id <- (map[PointHistoryModelKey.target_id], IntTransform())
        self.gaint_flg <- map[PointHistoryModelKey.gaint_flg]
        self.title     <- map[PointHistoryModelKey.title]
    }
}
