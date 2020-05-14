//
//  MyMenuRow.swift
//  Medicare
//
//  Created by sanghv on 3/10/20.
//

import Foundation

// MARK: - MyMenuRow1

enum MyMenuRow1: Int, CaseIterable {
    case point, changeUserInfo, notificationSettings, scanQRCode/*, dataTransfer, faq*/

    init(raw: Int) {
        self = MyMenuRow1(rawValue: raw) ?? .point
    }
}

extension MyMenuRow1 {

    var title: String {
        switch self {
        case .point:
            return R.string.localization.point.localized()
        case .changeUserInfo:
            return R.string.localization.changeUserInformation.localized()
        case .notificationSettings:
            return R.string.localization.notificationSettings.localized()
        case .scanQRCode:
            return R.string.localization.qrCodeReading.localized()
        /*
        case .dataTransfer:
            return R.string.localization.dataTransfer.localized()
        case .faq:
            return R.string.localization.frequentlyAskedQuestions.localized()
        */
        }
    }

    var icon: UIImage? {
        switch self {
        case .point:
            return R.image.menuPoint()
        case .changeUserInfo:
            return R.image.menuChangeUserInfo()
        case .notificationSettings:
            return R.image.menuNotification()
        case .scanQRCode:
            return R.image.scanQrCode()
        /*
        case .dataTransfer:
            return R.image.menuTransfer()
        case .faq:
            return R.image.menuEmpty()
        */
        }
    }
}

// MARK: - MyMenuRow2

enum MyMenuRow2: Int, CaseIterable {
    case faq, terms, privacy, /*sctl,*/ logout, unregister, versionInfo

    init(raw: Int) {
        self = MyMenuRow2(rawValue: raw) ?? .terms
    }
}

extension MyMenuRow2 {

    var title: String {
        switch self {
        case .faq:
            return R.string.localization.frequentlyAskedQuestions.localized()
        case .terms:
            return R.string.localization.termsOfService.localized()
        case .privacy:
            return R.string.localization.privacyPolicy.localized()
        case .logout:
            return R.string.localization.logoutTitle.localized()
        case .unregister:
            return R.string.localization.unregisterStringTitle.localized()
        /*
        case .sctl:
            return R.string.localization.specifiedCommercialTransactionLaw.localized()
        */
        case .versionInfo:
            return R.string.localization.versionInformation.localized()
        }
    }
}
