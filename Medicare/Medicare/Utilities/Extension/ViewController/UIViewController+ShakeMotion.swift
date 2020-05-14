//
//  UIViewController+ShakeMotion.swift
//  Medicare
//
//  Created by sanghv on 1/4/20.
//

import UIKit

#warning("Temporary for debugging")
extension UIViewController {

    // We are willing to become first responder to get shake motion
    override open var canBecomeFirstResponder: Bool {
        return true
    }

    // Enable detection of shake motion
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if isDebug && motion == .motionShake {
            navigationController?.popViewController(animated: true)
        }
    }
}
