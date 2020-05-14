//
//  NumberFormatter.swift
//  Medicare
//
//  Created by sanghv on 11/11/19.
//

import Foundation

var groupNumberFormatter: NumberFormatter {
    struct Static {
        static let instance: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumIntegerDigits = 1
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 8
            numberFormatter.locale = Locale(identifier: "ja_JP")

            return numberFormatter
        }()
    }

    return Static.instance
}

var decimalForTransformFormatter: NumberFormatter {
    struct Static {
        static let instance: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale(identifier: "ja_JP")

            return numberFormatter
        }()
    }

    return Static.instance
}

var decimalZeroMinimumFractionDigitsFormatter: NumberFormatter {
    struct Static {
        static let instance: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.allowsFloats = true
            numberFormatter.minimumIntegerDigits = 1
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 8
            numberFormatter.locale = Locale(identifier: "ja_JP")

            return numberFormatter
        }()
    }

    return Static.instance
}

var decimalTwoMinimumFractionDigitsFormatter: NumberFormatter {
    struct Static {
        static let instance: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.allowsFloats = true
            numberFormatter.minimumIntegerDigits = 1
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 8
            numberFormatter.locale = Locale(identifier: "ja_JP")

            return numberFormatter
        }()
    }

    return Static.instance
}
