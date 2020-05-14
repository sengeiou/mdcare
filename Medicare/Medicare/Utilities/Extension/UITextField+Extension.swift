//
//  UITextField+Extension.swift
//  Medicare
//
//  Created by Thuan on 3/5/20.
//

import Foundation

extension UITextField {

    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

}
