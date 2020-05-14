//
//  Gateway.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Moya
import SwiftyJSON
import ObjectMapper

/** Gateway protocol

*/

public typealias RequestSuccessClosure = (() -> Void)
public typealias RequestSuccessWithDataClosure = ((Any) -> Void)
public typealias RequestFailureClosure = ((String?) -> Void)

public struct ResponseKey {
    static let result     = "result"
    static let errors     = "errors"
    static let code       = "code"
    static let message    = "message"
    static let accessToken = "accessToken"
    static let data       = "data"
    static let totalPages = "total_pages"
}

public func SimpleRequestFailureHandler(_ reason: String?) {
    popHUDActivity()
}

public func DefaultRequestFailureHandler(_ errorResponse: Response?, isAutoAlert: Bool = true) -> String {
    // Check statusCode and handle desired errors
    popHUDActivity()

    var msg = ""

    do {
        switch errorResponse?.statusCode {
        case -1009:
            msg = R.string.localization.networkErrorOfflineMsg.localized()
        case -1001:
            msg = R.string.localization.timedoutMsg.localized()
        default:
            guard let errorJson = try errorResponse?.mapJSON() else {
                return TSConstants.EMPTY_STRING
            }

            let errorModel = Mapper<ErrorResultModel>().map(JSONObject: errorJson)
            if let errors = errorModel?.errors, !errors.isEmpty {
                let error = errors[0]
                if error.code == 401 {
                    backToFirstView()
                    return ""
                } else if error.code == 410 {
                    showAppStoreUpdate(errorModel?.data?.value)
                    return ""
                }
                msg = error.message ?? TSConstants.EMPTY_STRING
            } else if let json = errorJson as? [String: String] {
                msg = json[ResponseKey.message] ?? TSConstants.EMPTY_STRING
            } else {
                msg = TSConstants.EMPTY_STRING
            }
        }
    } catch {
        msg = TSConstants.EMPTY_STRING
    }

    if isAutoAlert && !msg.isEmpty {
        showAlert(msg, callback: nil)
    }
    return msg
}

public func backToFirstView() {
    prefs?.removeUserId()
    prefs?.removeUserToken()

    let firstVC = FirstViewController.newInstance()
    let navVC = UINavigationController(rootViewController: firstVC)
    navVC.setAsRootVCAnimated()
}

private func backToHome() {
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    if let tabBarController = rootViewController as? UITabBarController {
        let navigationController = tabBarController.selectedViewController as? UINavigationController
        navigationController?.popToRootViewController(animated: true)
    } else if let navigationController = rootViewController as? UINavigationController {
        navigationController.popToRootViewController(animated: true)
    }
}

private func showAlert(_ msg: String, callback: ((AlertControllerResult) -> Void)?) {
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    rootViewController?.presentAlertWith(message: msg, callback: callback)
}

private func showAppStoreUpdate(_ appId: String?) {
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    rootViewController?.presentConfirmAlertWith(message: "最新のバージョンがあります。",
                                                cancelTitle: "キャンセル",
                                                confirmButtonTitle: "アップデート",
                                                callback: { (alert) in
                                                    if alert.style == .default {
                                                        openAppStore(appId)
                                                    }
    })
}

private func openAppStore(_ appId: String?) {
    guard let appId = appId else {
        return
    }

    if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appId)"),
        UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

protocol Gateway {

}
