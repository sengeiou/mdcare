//
//  Gender.swift
//  Medicare
//
//  Created by sanghv on 4/22/20.
//

import Foundation

enum Gender: String, CaseIterable {
    case unknown = "", female = "2", male = "1"

    init(raw: String) {
        self = Gender(rawValue: raw) ?? .unknown
    }
}

extension Gender {

    var index: Int {
        switch self {
        case .unknown:
            return 0
        case .female:
            return 1
        case .male:
            return 2
        }
    }

    var title: String {
        switch self {
        case .unknown:
            return TSConstants.EMPTY_STRING
        case .male:
            return R.string.localization.male.localized()
        case .female:
            return R.string.localization.female.localized()
        }
    }
}
