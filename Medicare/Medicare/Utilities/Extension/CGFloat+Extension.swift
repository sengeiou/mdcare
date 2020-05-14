//
//  CGFloat+Extension.swift
//  Medicare
//
//  Created by sanghv on 11/12/19.
//

import Foundation

extension CGFloat {

    func toStringWith(fractionDigits: Int = 1) -> String {
        return String(format: "%.\(fractionDigits)f", self)
    }

    func toRadians() -> CGFloat {
        return (self / 180) * .pi
    }

    func toDegrees() -> CGFloat {
        return (self / .pi) * 180
    }
}
