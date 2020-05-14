//
//  UIAlertController+Rx.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation
import UIKit

typealias AlertControllerResult = (style: UIAlertAction.Style, buttonIndex: Int)

///Alert Style
extension UIAlertController {
    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithTitle(title: String?,
                              message: String?,
                              cancelTitle ct: String?,
                              destructiveTitle dt: String?,
                              otherTitles: [String],
                              callback: ((AlertControllerResult) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for (index, title) in otherTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default) { _ in
                callback?((.default, index))
            }
            alert.addAction(action)
        }

        if let ct = ct {
            let cancelAction = UIAlertAction(title: ct, style: .cancel) { _ in
                callback?((.cancel, 0))
            }
            alert.addAction(cancelAction)
        }

        if let dt = dt {
            let destructiveAction =  UIAlertAction(title: dt, style: .destructive) { _ in
                callback?((.destructive, 0))
            }
            alert.addAction(destructiveAction)
        }

        return alert
    }

    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithTitle(title: String?,
                              message: String?,
                              cancelTitle ct: String?,
                              otherTitles: [String],
                              callback: ((AlertControllerResult) -> Void)?) -> UIAlertController {
        return alertWithTitle(title: title,
                              message: message,
                              cancelTitle: ct,
                              destructiveTitle: nil,
                              otherTitles: otherTitles,
                              callback: callback)
    }

    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithMessage(message: String?,
                                cancelTitle ct: String?,
                                otherTitles: [String],
                                callback: ((AlertControllerResult) -> Void)?) -> UIAlertController {
        return alertWithTitle(title: nil,
                              message: message,
                              cancelTitle: ct,
                              destructiveTitle: nil,
                              otherTitles: otherTitles,
                              callback: callback)
    }

    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithMessage(message: String?,
                                cancelTitle ct: String,
                                callback: ((AlertControllerResult) -> Void)? = nil) -> UIAlertController {
        return alertWithTitle(title: nil,
                              message: message,
                              cancelTitle: ct,
                              destructiveTitle: nil,
                              otherTitles: [],
                              callback: callback)
    }

    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithMessage(message: String?,
                                callback: ((AlertControllerResult) -> Void)? = nil) -> UIAlertController {
        return alertWithTitle(title: nil,
                              message: message,
                              cancelTitle: R.string.localization.buttonOkTitle.localized(),
                              destructiveTitle: nil,
                              otherTitles: [],
                              callback: callback)
    }

    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithTitle(title: String?,
                              message: String?,
                              callback: ((AlertControllerResult) -> Void)? = nil) -> UIAlertController {
        return alertWithTitle(title: title,
                              message: message,
                              cancelTitle: R.string.localization.buttonOkTitle.localized(),
                              destructiveTitle: nil,
                              otherTitles: [],
                              callback: callback)
    }

    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    @discardableResult
    class func alertWithTitle(title: String?,
                              message: String?,
                              cancelTitle ct: String?,
                              callback: ((AlertControllerResult) -> Void)? = nil) -> UIAlertController {
        return alertWithTitle(title: title,
                              message: message,
                              cancelTitle: ct,
                              destructiveTitle: nil,
                              otherTitles: [],
                              callback: callback)
    }
}

/// ActionSheet
extension UIAlertController {
    /// Creates a action sheet
    @discardableResult
    class func actionSheetWithTitle(title: String? = nil,
                                    cancelTitle ct: String? = nil,
                                    destructiveTitle dt: String? = nil,
                                    otherTitles: [String] = [],
                                    callback: ((AlertControllerResult) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        for (index, title) in otherTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default) { _ in
                callback?((.default, index))
            }
            alert.addAction(action)
        }

        if let ct = ct {
            let cancelAction = UIAlertAction(title: ct, style: .cancel) { _ in
                callback?((.cancel, 0))
            }
            alert.addAction(cancelAction)
        }

        if let dt = dt {
            let destructiveAction =  UIAlertAction(title: dt, style: .destructive) { _ in
                callback?((.destructive, 0))
            }
            alert.addAction(destructiveAction)
        }

        return alert
    }
}
