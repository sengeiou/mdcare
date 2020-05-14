//
//  AttributesStringDefinedConfig.swift
//  Medicare
//
//  Created by sanghv on 1/1/20.
//

import Foundation

func buildAttributesConfig(font: UIFont, color: UIColor) -> [NSAttributedString.Key: Any] {
    return [
        .font: font,
        .foregroundColor: color
    ]
}

func lineHeightConfig(_ heightMultiple: CGFloat,
                      alignment: NSTextAlignment = .center) -> [NSAttributedString.Key: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = heightMultiple
    paragraphStyle.alignment = alignment

    return [
        .paragraphStyle: paragraphStyle
    ]
}
