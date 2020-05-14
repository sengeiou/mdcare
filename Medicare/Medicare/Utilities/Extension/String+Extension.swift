//
//  String+Extension.swift
//  Medicare
//
//  Created by sanghv on 10/27/19.
//

import Foundation

extension String {

    public func attributeString(configs: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributesString = NSMutableAttributedString(string: self, attributes: configs)

        return attributesString
    }

    public func toJPCharacter(_ jpCharacter: TextConverter.JPCharacter = TextConverter.JPCharacter.katakana) -> String {
        return TextConverter.convert(self, to: jpCharacter)
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    // 「カタカナ」かどうか
    var isKatakana: Bool {
        let range = "^[ァ-ヶー]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
}
