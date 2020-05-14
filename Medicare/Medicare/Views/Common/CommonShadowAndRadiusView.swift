//
//  CommonShadowAndRadiusView.swift
//  Medicare
//
//  Created by Thuan on 3/5/20.
//

import Foundation

class CommonShadowAndRadiusView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    fileprivate func setupView() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 7
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
}
