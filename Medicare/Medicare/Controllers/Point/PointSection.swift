//
//  PointSection.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import Foundation

enum PointSection: Int, CaseIterable {
    case balance, history

    init(raw: Int) {
        self = PointSection(rawValue: raw) ?? .balance
    }
}

extension PointSection {

    var title: String {
        switch self {
        case .balance:
            return R.string.localization.currentPointBalance.localized()
        case .history:
            return R.string.localization.pointAcquisitionUseHistory.localized()
        }
    }
}
