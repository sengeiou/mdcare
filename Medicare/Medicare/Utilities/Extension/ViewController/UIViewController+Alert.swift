//
//  UIviewController+Utility.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

// MARK: - Alert Style
extension UIViewController {
    // MARK: - Show alert controller: simply alert controller
    /**
     Display Alert Controller to user (simlpy use presentViewController for now), alertController should be configured with callbacks first.
     - Parameter alert: UIAlertController to be displayed on top of this viewcontroller instance.
     */
    func showAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Rx Extension for showing alert view controllers.
    /**
     Rx convenient function for display alert, .Next, .Completed delivered.
     - Returns: Observable\<AlertControllerResult\>
     */
    func rx_alertWithTitle(title: String?,
                           message: String?,
                           cancelTitle ct: String?,
                           destructiveTitle dt: String?,
                           otherTitles ot: [String]) -> Observable<AlertControllerResult> {
        let ob: Observable<AlertControllerResult> = Observable.create { [weak self] observer -> Disposable in
            guard let weakSelf = self else {
                observer.on(.completed)
                return Disposables.create()
            }
            let alert = UIAlertController.alertWithTitle(title: title,
                                                         message: message,
                                                         cancelTitle: ct,
                                                         destructiveTitle: dt,
                                                         otherTitles: ot,
                                                         callback: { (result) -> Void in
                                                            observer.on(.next(result))
                                                            observer.on(.completed)
            })
            weakSelf.showAlertController(alert: alert)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        return ob.observeOn(MainScheduler.instance)
    }

    /**
     Rx convenient function for display alert, .Next, .Completed delivered.
     - Returns: Observable\<AlertControllerResult\>
     */
    func rx_alertWithTitle(title: String?,
                           message: String?,
                           cancelTitle ct: String?,
                           otherTitles: [String]) -> Observable<AlertControllerResult> {
        return rx_alertWithTitle(title: title,
                                 message: message,
                                 cancelTitle: ct,
                                 destructiveTitle: nil,
                                 otherTitles: otherTitles)
    }

    /**
     Rx convenient function for display alert, .Next, .Completed delivered.
     - Returns: Observable\<AlertControllerResult\>
     */
    func rx_alertWithMessage(message: String?,
                             cancelTitle ct: String?,
                             otherTitles: [String]) -> Observable<AlertControllerResult> {
        return rx_alertWithTitle(title: nil,
                                 message: message,
                                 cancelTitle: ct,
                                 destructiveTitle: nil,
                                 otherTitles: otherTitles)
    }

    /**
     Rx convenient function for display alert, .Next, .Completed delivered.
     - Returns: Observable\<AlertControllerResult\>
     */
    func rx_alertWithMessage(message: String?,
                             cancelTitle ct: String) -> Observable<()> {
        return rx_alertWithTitle(title: nil,
                                 message: message,
                                 cancelTitle: ct,
                                 destructiveTitle: nil,
                                 otherTitles: []).map { _, _ in
                                    return ()
        }
    }

    /**
     Rx convenient function for display alert, .Next, .Completed delivered.
     - Returns: Observable\<()\>
     */
    func rx_alertWithMessage(message: String?) -> Observable<()> {
        return rx_alertWithTitle(title: nil,
                                 message: message,
                                 cancelTitle: R.string.localization.buttonOkTitle.localized(),
                                 destructiveTitle: nil,
                                 otherTitles: []).map { _, _  in
                                    return ()
        }
    }

    /**
     Rx convenient function for display alert, .Next, .Completed delivered.
     - Returns: Observable\<()\>
     */
    func rx_alertWithTitle(title: String?,
                           message: String?) -> Observable<()> {
        return rx_alertWithTitle(title: title,
                                 message: message,
                                 cancelTitle: R.string.localization.buttonOkTitle.localized(),
                                 otherTitles: []).map { _, _ -> Void in
                                    return ()
        }
    }
}

// MARK: - ActionSheetStyle
extension UIViewController {
    /**
     Rx convenient function for displaying action sheet from source view.
     */
    func rx_actionSheetFromView(sourceView: UIView,
                                title: String? = nil,
                                cancelTitle ct: String? = nil,
                                destructiveTitle dt: String? = nil,
                                otherTitles: [String] = []) -> Observable<AlertControllerResult> {
        let ob: Observable<AlertControllerResult> = Observable.create { [weak self] observer -> Disposable in
            guard let weakSelf = self else {
                observer.on(.completed)
                return Disposables.create()
            }
            let alert = UIAlertController.actionSheetWithTitle(title: title,
                                                               cancelTitle: ct,
                                                               destructiveTitle: dt,
                                                               otherTitles: otherTitles,
                                                               callback: { (result) -> Void in
                                                                observer.on(.next(result))
                                                                observer.on(.completed)
            })
            alert.popoverPresentationController?.sourceView = sourceView
            weakSelf.showAlertController(alert: alert)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        return ob.observeOn(MainScheduler.instance)
    }

    /**
     Rx convenient function for displaying action sheet from bar button item
     */
    func rx_actionSheetFromBarButtonItem(barButtonItem: UIBarButtonItem,
                                         title: String? = nil,
                                         cancelTitle ct: String? = nil,
                                         destructiveTitle dt: String? = nil,
                                         otherTitles: [String] = []) -> Observable<AlertControllerResult> {
        let ob: Observable<AlertControllerResult> = Observable.create { [weak self] observer -> Disposable in
            guard let weakSelf = self else {
                observer.on(.completed)
                return Disposables.create()
            }
            let alert = UIAlertController.actionSheetWithTitle(title: title,
                                                               cancelTitle: ct,
                                                               destructiveTitle: dt,
                                                               otherTitles: otherTitles,
                                                               callback: { (result) -> Void in
                                                                observer.on(.next(result))
                                                                observer.on(.completed)
            })
            alert.popoverPresentationController?.barButtonItem = barButtonItem
            weakSelf.showAlertController(alert: alert)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        return ob.observeOn(MainScheduler.instance)
    }
}

// MARK: - Custom Alert
extension UIViewController {

    func presentCustomAlertWith(title: String?,
                                image: UIImage?,
                                message: String?,
                                subMessage: String? = nil,
                                okButtonTitle: String?,
                                dismissActionCallback: DismissActionCallback? = nil) {
        let customAlertViewController = CustomAlertViewController.newInstance().then {
            $0.title = title
            $0.image = image
            $0.message = message
            $0.subMessage = subMessage
            $0.okButtonTitle = okButtonTitle
            $0.dismissActionCallback = dismissActionCallback
        }

        let formSheetController = MZFormSheetPresentationViewController(
            contentViewController: customAlertViewController
        ).then {
            $0.contentViewControllerTransitionStyle = .bounce
            $0.contentViewCornerRadius = 10.0
        }

        formSheetController.presentationController?.contentViewSize = UIView.layoutFittingCompressedSize
        // formSheetController.willDismissContentViewControllerHandler = dismissActionCallback

        present(formSheetController, animated: true, completion: nil)
    }

    func presentAlertWith(message: String?) {
        presentConfirmAlertWith(message: message, confirmButtonTitle: "", callback: nil)
    }

    func presentAlertWith(message: String?, callback: ((AlertControllerResult) -> Void)?) {
        let alert = UIAlertController.alertWithTitle(title: "めりぃさん", message: message, callback: callback)
        present(alert, animated: true, completion: nil)
    }

    func presentConfirmAlertWith(message: String?,
                                 cancelTitle: String = R.string.localization.buttonCancelTitle.localized(),
                                 confirmButtonTitle: String,
                                 callback: ((AlertControllerResult) -> Void)?) {
        let alert = UIAlertController.alertWithMessage(message: message,
                                                       cancelTitle: cancelTitle,
                                                       otherTitles: [confirmButtonTitle],
                                                       callback: callback)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ElsaAlertExtension
enum ElsaAlertVCResult {
    case clicked(Int) // When click any button
    case cancelled    // When tap close button
}
