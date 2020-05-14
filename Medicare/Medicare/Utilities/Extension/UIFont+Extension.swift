//
//  UIFont+Extension.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import UIKit

extension UIFont {

    // MARL: - Font

    open class func bold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }

    open class func medium(size: CGFloat) -> UIFont {
//        return R.font.hiraginoSansGBW6(size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }

    open class func regular(size: CGFloat) -> UIFont {
//        return R.font.hiraginoSansGBW3(size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }

    /*
    open class func light(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
    */
}
