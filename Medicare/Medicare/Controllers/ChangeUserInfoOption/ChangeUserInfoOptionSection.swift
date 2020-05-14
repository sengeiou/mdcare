//
//  ChangeUserInfoOptionSection.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import Foundation

enum ChangeUserInfoOptionSection: Int, CaseIterable {
    case option

    init(raw: Int) {
        self = ChangeUserInfoOptionSection(rawValue: raw) ?? .option
    }
}

extension ChangeUserInfoOptionSection {

    var title: String {
        switch self {
        case .option:
            return TSConstants.EMPTY_STRING
        }
    }
}
