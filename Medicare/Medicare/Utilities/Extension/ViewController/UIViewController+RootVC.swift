//
//  UIViewController+RootVC.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation

extension UIViewController {
    // MARK: - Transit Root View Controller
    /**
     Change application's rootview controller with current viewcontroller with CrossDissolve transition
     */
    func setAsRootVCAnimated() {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let originalVC = keyWindow?.rootViewController
        guard let window = keyWindow else {
            return
        }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: { () -> Void in
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = self
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            originalVC?.dismiss(animated: false, completion: nil)
        })
    }

    /**
     Set as root view controller
     */
    func setAsRoot() {
        //Remember original root vc first.
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let originalVC = keyWindow?.rootViewController
        keyWindow?.rootViewController = self

        // After this, dismiss all original VC's stack
        originalVC?.dismiss(animated: false, completion: nil)
    }
}
