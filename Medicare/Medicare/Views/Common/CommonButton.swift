//
//  CommonButton.swift
//  Medicare
//
//  Created by Thuan on 3/2/20.
//

import Foundation

class CommonButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    convenience init(type: ButtonType, frame: CGRect) {
        self.init(type: type)

        self.frame = frame
        setupView()
    }

    fileprivate func setupView() {
        clipsToBounds = false
        layer.cornerRadius = 5
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        backgroundColor = ColorName.c7DCBCC.color
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = .medium(size: 16)
        titleLabel?.adjustsFontSizeToFitWidth = true
//        dropShadowForCommonButton()
    }
}
