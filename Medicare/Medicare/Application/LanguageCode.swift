//
//  LanguageCode.swift
//  Medicare
//
//  Created by sanghv on 2/13/20.
//

import Foundation

enum LanguageCode: String {
    case base = "Base"
    case en
    case vi
}

extension LanguageCode {

    var name: String {
        switch self {
        case .en:
            return TSConstants.EMPTY_STRING
        default:
            return TSConstants.EMPTY_STRING
        }
    }

    var flagIcon: UIImage? {
        switch self {
        case .en:
            return R.image.unitedStatesOfAmerica()
        default:
            return R.image.vietnam()
        }
    }
}
