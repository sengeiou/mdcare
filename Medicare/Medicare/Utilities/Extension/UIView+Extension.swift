//
//  UIView+Extension.swift
//  Medicare
//
//  Created by Thuan on 3/2/20.
//

import Foundation

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        get {
            return 0
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return 0
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable var masksToBounds: Bool {
        get {
            return false
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }

    func roundTopCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.topLeft, .topRight], radius: 10, borderColor: UIColor.clear.cgColor)
    }

    func roundBottomCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10, borderColor: UIColor.clear.cgColor)
    }

    func unroundAllCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.allCorners], radius: 0, borderColor: UIColor.clear.cgColor)
    }

    func roundAllCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor.clear.cgColor)
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: CGColor) {
        let path = UIBezierPath.init(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask

        let borderPath = UIBezierPath.init(roundedRect: self.bounds,
                                           byRoundingCorners: corners,
                                           cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = 2
        borderLayer.strokeColor = borderColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
