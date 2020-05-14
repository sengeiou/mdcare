//
//  Utils.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation
import UIKit

// MARK: - Define constant to check debug env flag

#if DEBUG
    let isDebug = true
#else
    let isDebug = false
#endif

// MARK: - AppDelegate instance

let appDelegate = UIApplication.shared.delegate as? AppDelegate

let windowAppDelegate = appDelegate?.window

// MARK: - Screen scale

let screenScale = UIScreen.main.nativeScale

let screenWidth = UIScreen.main.bounds.width

// MARK: - App version

let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String

// MARK: - Color from hex utility

func colorFromHex(_ hexString: String) -> UIColor? {
    let color = UIColor(hexString: hexString)

    return color
}

// MARK: - Share preferences

let prefs = GlobalContext.get(key: GlobalContext.PREFS)

func classFromString(_ className: String) -> AnyClass? {

    // Get namespace
    guard var namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
        return nil
    }

    namespace = namespace.replacingOccurrences(of: TSConstants.WHITESPACE_STRING, with: StringConstant.underline)

    // Get 'anyClass' with classname and namespace
    let cls: AnyClass? = NSClassFromString("\(namespace).\(className)")

    // Return AnyClass?
    return cls
}

func showAlert(title: String? = appName, subtitle: String) {

}

func showError(withStatus status: String) {
    // Dismiss HUD
    SVProgressHUD.popActivity()
}

func showSuccess(withStatus status: String) {
    SVProgressHUD.setForegroundColor(ColorName.c333333.color)
    SVProgressHUD.setBackgroundColor(.clear)
    SVProgressHUD.setDefaultMaskType(.none) // Allow user interactions while HUD is displayed
    SVProgressHUD.showSuccess(withStatus: status)
    DispatchQueue.main.asyncAfter(deadline: .now() + NumberConstant.hudMaximumDismissTimeInterval) {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setForegroundColor(.clear)
        SVProgressHUD.setBackgroundColor(.clear)
    }
}

func showHUDActivity() {
    SVProgressHUD.show()
}

func showHUDAndAllowUserInteractionEnabled() {
    SVProgressHUD.setDefaultMaskType(.none) // Allow user interactions while HUD is displayed
    SVProgressHUD.show()
    DispatchQueue.main.asyncAfter(deadline: .now() + NumberConstant.hudMaximumDismissTimeInterval) {
        SVProgressHUD.setDefaultMaskType(.clear)
    }
}

func showHUDIfInvisible() {
    if !SVProgressHUD.isVisible() {
        SVProgressHUD.show()
    }
}

func popHUDActivity() {
    if SVProgressHUD.isVisible() {
        SVProgressHUD.popActivity()
    }
}

func dismissHUD() {
    SVProgressHUD.dismiss()
}

func gotoSetting() {
    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

func isPhoneNumber(_ phone: String) -> Bool {
    let PHONE_REGEX = "^((\\+)|(0))[0-9]{6,14}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: phone)
    return result

}

var hasTopNotch: Bool {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }

    return false
}

func sizeLabel(_ text: String) -> CGRect {
    let label = UILabel(frame: CGRect.zero)
    label.text = text
    label.sizeToFit()
    return label.frame
}

var isIpad: Bool {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
}
