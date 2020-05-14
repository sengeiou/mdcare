//
//  AppConstants.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation
import SwiftHEXColors

// MARK: - Hex color constant

enum ColorName: String {
    case white      = "FFFFFF"
    case black      = "000000"
    case c333333    = "333333"
    case cCCCCCC    = "CCCCCC"
    case cEDEDED    = "EDEDED"
    case cC4C4C4    = "C4C4C4"
    case cF9F9F9    = "F9F9F9"
    case cDFDFDF    = "DFDFDF"
    case cB1B1B1    = "B1B1B1"
    case cC95851    = "C95851"
    case c666666    = "666666"
    case cED9E9E    = "ED9E9E"
    case cFFCCDE    = "FFCCDE"
    case c525263    = "525263"
    case cD1D4D9    = "D1D4D9"
    case dark1      = "222222"
    case dark2      = "444444"
    case dark3      = "404850"
    case dark5      = "181818"
    case dark7      = "595757"
    case light1     = "CDCDCD"
    case red        = "F20000"
    case red1       = "F80000"
    case green      = "009933"
    case orange     = "FF9900"
    case orange1    = "FB6E41"
    case gray1      = "AAAAAA"
    case gray2      = "C0C0C0"
    case c656565    = "656565"
    case c7B7B7B    = "7B7B7B"
    case c5E5E5E    = "5E5E5E"
    case cCC0D3F    = "CC0D3F"
    case c008DDC    = "008DDC"
    case c1390CF    = "1390CF"
    case cFFE2DF    = "FFE2DF"
    case c716969    = "716969"
    case c1104A4    = "1104A4"
    case cF18BB0    = "F18BB0"
    case c0092C4    = "0092C4"
    case cFFE9F1    = "FFE9F1"
    case cE84680    = "E84680"
    case cE1E1E1    = "E1E1E1"
    case cFF7D7D    = "FF7D7D"
    case c7DC9FF    = "7DC9FF"
    case cB40041    = "B40041"
    case c7DCBCC    = "7DCBCC"
    case cA5BE51    = "A5BE51"
    case cDF4840    = "DF4840"
    case cF2F2F2    = "F2F2F2"

    var color: UIColor {
        guard let color = colorFromHex(rawValue) else {
            fatalError()
        }

        return color
    }
}

// MARK: - Number constant

struct NumberConstant {
    // swiftlint:disable colon
    static let throttleValue                  : RxSwift.RxTimeInterval = 0.2
    static let commonCornerRadius             : CGFloat                = 8.0
    static let commonFontSize                 : CGFloat                = 14.0
    static let commonMargin                   : CGFloat                = 16.0
    static let minScreenWidth                 : CGFloat                = 375.0
    static let minHeaderHeightForGroupedTable : CGFloat                = CGFloat.leastNonzeroMagnitude
    static let hudMaximumDismissTimeInterval  : TimeInterval           = 2.0 // second
    static let imageSlideshowTimmer           : Double                 = 5.0
    static let commonBottomPadding            : CGFloat                = 30.0
    static let nameLength                     : Int                    = 100
    static let phoneLength                    : Int                    = 20
    static let zipcodeLength                  : Int                    = 7
    static let zipcodeMaxLength               : Int                    = 7
    static let addressLength                  : Int                    = 512
    static let buildingLength                 : Int                    = 512
    static let pageSize                       : Int                    = 10
    static let startPageIndex                 : Int                    = 0
    // swiftlint:enable colon
}

// MARK: - String constant

struct StringConstant {
    static let hexSpace                   = "\u{00a0}"

    static let colon                      = ":"
    static let underline                  = "_"
    static let networkOfflineNotification = "NetworkOfflineNotification"
    static let privacyLink                = ""
    static let reloadTabBarNotification   = "reloadTabBarNotification"
    static let videoBackNotification      = "videoBackNotification"
    static let categorySettingChangesNotification = "categorySettingChangesNotification"
}

enum ErrorCode {

}
