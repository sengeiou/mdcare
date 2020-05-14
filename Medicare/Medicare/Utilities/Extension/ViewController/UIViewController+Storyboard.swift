//
//  UIViewController+Storyboard.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import UIKit

extension UIViewController {

    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboardHelper(name)
    }

    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: self)
        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Can't get view controller from storyboard \(name)")
        }

        return controller
    }
}
