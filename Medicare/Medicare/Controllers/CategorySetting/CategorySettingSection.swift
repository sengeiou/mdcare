//
//  CategorySettingSection.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import Foundation

enum CategorySettingSection: Int, CaseIterable {
    case category, tag

    init(raw: Int) {
        self = CategorySettingSection(rawValue: raw) ?? .category
    }
}

extension CategorySettingSection {

    var title: String {
        switch self {
        case .category:
            return R.string.localization.pleaseSelectTheCategoryYouAreInterestedIn.localized()
        case .tag:
            return R.string.localization.selectTagsOfInterest.localized()
        }
    }
}
