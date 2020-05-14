//
//  ConfigDataModel.swift
//  Medicare
//
//  Created by Thuan on 4/28/20.
//

import Foundation
import ObjectMapper

enum ConfigType: String {
    case appConfiguration = "APP_CONFIGURATION"
    case appInstructionText = "APP_INSTRUCTION_TEXT"
    case appBanner = "APP_BANNER"
}

enum ConfigKey: String {
    case appId = "app_id"
    case presentApplicationSuccessful = "present_application_successful"
    case magazineSubscribe = "magazine_subcribe"
}

enum ConfigOS: String {
    case iOS = "1"
    case android = "2"
}

final class ConfigDataModel: BaseModel {

    // MARK: - Properties

    var type: String?
    var key: String?
    var value: String?
    var valueAsURL: URL?
    var os: String?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.type <- map["type"]
        self.key <- map["key"]
        self.value <- map["value"]
        self.valueAsURL <- (map["value"], URLTransform())
        self.os <- map["os"]
    }
}
