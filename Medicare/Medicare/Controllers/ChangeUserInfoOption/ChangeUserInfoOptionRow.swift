//
//  ChangeUserInfoOptionRow.swift
//  Medicare
//
//  Created by sanghv on 3/10/20.
//

import Foundation

enum ChangeUserInfoOptionRow: Int, CaseIterable {
    case categoryAndTag, personalInfo, magazineSubscriptionInfo

    init(raw: Int) {
        self = ChangeUserInfoOptionRow(rawValue: raw) ?? .categoryAndTag
    }
}

extension ChangeUserInfoOptionRow {

    var title: String {
        switch self {
        case .categoryAndTag:
            return R.string.localization.categoryTags.localized()
        case .personalInfo:
            return R.string.localization.changePersonalInformation.localized()
        default:
            return R.string.localization.subscriptionInfoTitle.localized()
        }
    }
}
