//
//  UIViewController+TabBar.swift
//  Medicare
//
//  Created by sanghv on 2/17/20.
//

import UIKit

extension UIViewController {

    @objc func setTabBarVisible(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        tabBarController?.setTabBarVisible(visible: visible,
                                           animated: animated,
                                           duration: duration)
    }

    var isTabBarVisible: Bool {
        return tabBarController?.tabBarIsVisible() ?? false
    }

    var tabBarIsMoving: Bool {
        return tabBarController?.tabBarIsMoving() ?? false
    }
}

extension UIViewController {

    @objc func shouldToogleTabBarByScrolling() -> Bool {
        return true
    }

    @objc func extendBottomInsetIfNeed(for scrollView: UIScrollView) {
        var contentInset = scrollView.contentInset
        contentInset.bottom = tabBarController?.tabBar.bounds.height ?? 0.0
        scrollView.contentInset = contentInset

        let scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: -contentInset.bottom,
                                                 right: 0)
        if #available(iOS 11.1, *) {
            scrollView.verticalScrollIndicatorInsets = scrollIndicatorInsets
        } else {
            scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        }
    }
}
