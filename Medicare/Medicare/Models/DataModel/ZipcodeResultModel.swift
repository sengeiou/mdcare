//
//  ZipcodeResultModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct ZipcodeResultModelKey {
    static let prefectureName     = "prefecture_name"
    static let cityName           = "city_name"
    static let townName           = "town_name"
    static let prefectureNameKana = "prefecture_name_kana"
    static let cityNameKana       = "city_name_kana"
    static let townNameKana       = "town_name_kana"
    static let prefcode           = "prefecture_jis_code"
    static let zipcode            = "zip_code"
}

final class ZipcodeResultModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var prefectureName     : String = TSConstants.EMPTY_STRING
    var cityName           : String = TSConstants.EMPTY_STRING
    var townName           : String = TSConstants.EMPTY_STRING
    var prefectureNameKana : String = TSConstants.EMPTY_STRING
    var cityNameKana       : String = TSConstants.EMPTY_STRING
    var townNameKana       : String = TSConstants.EMPTY_STRING
    var prefcode           : String = TSConstants.EMPTY_STRING
    var zipcode            : String = TSConstants.EMPTY_STRING
    // swiftlint:enable colon

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.prefectureName     <- map[ZipcodeResultModelKey.prefectureName]
        self.cityName           <- map[ZipcodeResultModelKey.cityName]
        self.townName           <- map[ZipcodeResultModelKey.townName]
        self.prefectureNameKana <- map[ZipcodeResultModelKey.prefectureNameKana]
        self.cityNameKana       <- map[ZipcodeResultModelKey.cityNameKana]
        self.townNameKana       <- map[ZipcodeResultModelKey.townNameKana]
        self.prefcode           <- map[ZipcodeResultModelKey.prefcode]
        self.zipcode            <- map[ZipcodeResultModelKey.zipcode]
    }
}
