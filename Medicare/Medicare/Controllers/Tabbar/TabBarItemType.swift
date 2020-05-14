//
//  TabBarItemType.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import Foundation

enum TabBarItemType: Int, CaseIterable {
    case magazine
    case present
    case shopping
    case video
}

extension TabBarItemType {

    var title: String {
        switch self {
        case .magazine:
            return R.string.localization.tabBarString001.localized()
        case .present:
            return R.string.localization.tabBarString002.localized()
        case .shopping:
            return R.string.localization.tabBarString003.localized()
        case .video:
            return R.string.localization.tabBarString004.localized()
        }
    }
}
