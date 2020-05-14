//
//  UIView+Shadow.swift
//  Medicare
//
//  Created by sanghv on 6/27/19.
//

import Foundation

extension UIView {

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 3

        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadow(color: UIColor = UIColor.black,
                    opacity: Float = 1,
                    offSet: CGSize,
                    radius: CGFloat = 3,
                    scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadowForContainer() {
        dropShadow(
            color: ColorName.black.color.withAlphaComponent(0.1),
            offSet: .zero,
            radius: 7,
            scale: true
        )
    }

    func dropShadowForCommonButton() {
        dropShadow(
            color: ColorName.black.color,
            opacity: 0.25,
            offSet: CGSize(width: 0, height: 4),
            radius: 4,
            scale: true
        )
    }

    func dropShadowForMediaThumb() {
        dropShadow(
            color: ColorName.black.color.withAlphaComponent(0.1),
            offSet: CGSize(width: 2, height: 2),
            radius: 7,
            scale: true
        )
    }
}
