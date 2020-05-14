//
//  MyMenuSection.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import Foundation

enum MyMenuSection: Int, CaseIterable {
    case notification, menu1, menu2

    init(raw: Int) {
        self = MyMenuSection(rawValue: raw) ?? .menu1
    }
}

extension MyMenuSection {

    var title: String {
        switch self {
        case .notification:
            return R.string.localization.notice.localized()
        case .menu1:
            return R.string.localization.myMenu.localized()
        case .menu2:
            return TSConstants.EMPTY_STRING
        }
    }
}
