//
//  UIViewController+InteractivePop.swift
//  Medicare
//
//  Created by sanghv on 1/4/20.
//

import UIKit

extension UIViewController {

    func setInteractivePopGestureEnabled() {
        _ = navigationController?.then {
            $0.interactivePopGestureRecognizer?.delegate = self
            $0.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
