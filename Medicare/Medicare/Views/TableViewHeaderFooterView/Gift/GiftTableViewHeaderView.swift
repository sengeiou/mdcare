//
//  GiftTableViewHeaderView.swift
//  Medicare
//
//  Created by Thuan on 4/1/20.
//

import Foundation

final class GiftTableViewHeaderView: TSBaseTableViewHeaderFooterView {

    // MARK: IBOutlets

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var shadowView: UIView!

    // MARK: Variables

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension GiftTableViewHeaderView {

    override func configView() {
        super.configView()

        configLabel()
        configShadowView()
    }

    fileprivate func configLabel() {
        _ = lbTitle.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configShadowView() {
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = 1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -2)
        shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
}
