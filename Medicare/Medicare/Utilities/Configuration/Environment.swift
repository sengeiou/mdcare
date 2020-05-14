//
//  Environment.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation

enum Environment: String {
    case dev = "Dev"
    case qa = "QA"
    case prod = "Prod"
}

// MARK: - Crashlytics & APNS

extension Environment {

    var googleServicePath: String {
        switch self {
        case .dev:
            return R.file.googleServiceDevInfoPlist.path() ?? ""
        case .qa:
            return R.file.googleServiceInfoPlist.path() ?? ""
        case .prod:
            return R.file.googleServiceInfoPlist.path() ?? ""
        }
    }

    var pushApplicationKey: String {
        switch self {
        case .dev:
            return "a879ee7cc0c6bdebd26328eb1459a586608d606be41d4f971145e56d9c9703a9"
        case .qa:
            return "a879ee7cc0c6bdebd26328eb1459a586608d606be41d4f971145e56d9c9703a9"
        case .prod:
            return "9a126496849aed0c6d4f0b5fc08bca09b5e1729f13e54c6a3b4f89b4be1f261d"
        }
    }

    var pushClientKey: String {
        switch self {
        case .dev:
            return "98cdc8ca57f501bc1f0c70a9514ddab31ac91800933ab597cba08b37803baaf8"
        case .qa:
            return "98cdc8ca57f501bc1f0c70a9514ddab31ac91800933ab597cba08b37803baaf8"
        case .prod:
            return "cd9d82c925b36dd2463df2d20580444f5dbb1cf7981c1da042f73555515963cb"
        }
    }
}

// MARK: - API Config

extension Environment {

    var apiHost: String {
        switch self {
        case .dev:
            return "http://mdcare-ing.tk/api/"
        case .qa:
            return "https://meri.in-g.asia/api/"
        case .prod:
            return "https://app.merry.inc/api/"
        }
    }

    var resourceHost: String {
        switch self {
        case .dev:
            return "http://mdcare-ing.tk/"
        case .qa:
            return "https://meri.in-g.asia/"
        case .prod:
            return "https://app.merry.inc/"
        }
    }

    var apiVersion: String {
        switch self {
        case .dev:
            return ""
        case .qa:
            return ""
        case .prod:
            return ""
        }
    }
}
