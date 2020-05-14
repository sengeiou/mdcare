//
//  MagazineTabCollectionViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import UIKit
import XLPagerTabStrip

final class MagazineTabCollectionViewCell: ButtonBarViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var btnChannel: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var paddingLeftConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        configButton()
        configBgView()
    }

    fileprivate func configButton() {
        _ = btnChannel.then {
            $0.titleLabel?.font = .medium(size: 14)
            $0.setTitleColor(ColorName.c7B7B7B.color, for: .normal)
            $0.isUserInteractionEnabled = false
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }

    fileprivate func configBgView() {
        _ = bgView.then {
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
        }
    }

    func selectedItem(_ isSelected: Bool) {
        if isSelected {
            bgView.backgroundColor = ColorName.c7DCBCC.color
            btnChannel.setTitleColor(ColorName.white.color, for: .normal)
        } else {
            bgView.backgroundColor = ColorName.cE1E1E1.color
            btnChannel.setTitleColor(ColorName.c333333.color, for: .normal)
        }
    }

    func extendPaddingLeft(_ extend: Bool) {
        paddingLeftConstraint.constant = extend ? 10: 0
    }
}
