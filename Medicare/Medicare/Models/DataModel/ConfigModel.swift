//
//  ConfigModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct ConfigModelKey {
    static let selectedFolder = "selectedFolder"
    static let isAlwaysOn     = "isAlwaysOn"
}

final class ConfigModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var selectedFolder : URL?
    var isAlwaysOn     : Bool      = false
    // swiftlint:enable colon

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.selectedFolder <- (map[ConfigModelKey.selectedFolder], URLTransform())
        self.isAlwaysOn     <- map[ConfigModelKey.isAlwaysOn]
    }
}
