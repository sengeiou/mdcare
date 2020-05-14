//
//  NSMutableAttributedString+Extension.swift
//  Medicare
//
//  Created by Thuan on 3/17/20.
//

import Foundation

extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
