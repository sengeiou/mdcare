//
//  UILabel+Extension.swift
//  Medicare
//
//  Created by Thuan on 3/9/20.
//

import Foundation

extension UILabel {

    func updateWithSpacing(_ lineSpacing: Float) {
        let attributedString = NSMutableAttributedString(string: self.text!)
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineSpacing = CGFloat(lineSpacing)

        if let stringLength = self.text?.count {
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: mutableParagraphStyle,
                                          range: NSRange(location: 0, length: stringLength))
        }
        self.attributedText = attributedString
    }

    func setSpacingText(_ text: String) {
        self.text = text
        self.updateWithSpacing(10.0)
    }

    func setHTMLFromString(htmlText: String) {
        // swiftlint:disable:next line_length
        let modifiedFont = String(format: "<span style=\"font-family: SFUIText-Regular; font-size: 16px; color: #333333\">%@</span>", htmlText)
        // swiftlint:disable:end line_length
        do {
            let attrStr = try NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)

            self.attributedText = attrStr
        } catch {

        }
    }
}
