//
//  DetailGiftViewHeaderView.swift
//  Medicare
//
//  Created by Thuan on 3/20/20.
//

import UIKit

final class DetailGiftViewHeaderView: TSBaseTableViewHeaderFooterView {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var thumbnail: UIImageView!
    @IBOutlet fileprivate weak var lbShortDesc: UILabel!
    @IBOutlet fileprivate weak var lbDesc: UILabel!
    @IBOutlet fileprivate weak var btnLabel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension DetailGiftViewHeaderView {

    override func configView() {
        super.configView()

        configLabels()
        configThumbnail()
        configButton()
    }

    fileprivate func configLabels() {
        _ = lbShortDesc.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbDesc.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configThumbnail() {
        _ = thumbnail.then {
            $0.layer.cornerRadius = 10
            $0.masksToBounds = true
        }
    }

    fileprivate func configButton() {
        _ = btnLabel.then {
            $0.titleLabel?.font = .medium(size: 12)
            $0.setTitleColor(ColorName.white.color, for: .normal)
            $0.backgroundColor = ColorName.cFF7D7D.color
            $0.setTitle(R.string.localization.giftLabelSubscriber.localized(), for: .normal)
            $0.layer.cornerRadius = 3
        }
    }

    fileprivate func labelVisible(_ visible: Bool) {
        btnLabel.isHidden = !visible
        for constraint in btnLabel.constraints where
            constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = (visible) ? 24 : 0
        }
    }

    fileprivate func setupLabel(_ isMember: Bool) {
        if isMember {
            btnLabel.backgroundColor = ColorName.c7DC9FF.color
            btnLabel.setTitle(R.string.localization.giftLabelMember.localized(), for: .normal)
        } else {
            btnLabel.backgroundColor = ColorName.cFF7D7D.color
            btnLabel.setTitle(R.string.localization.giftLabelSubscriber.localized(), for: .normal)
        }
    }
}

extension DetailGiftViewHeaderView {

    func setData(_ gift: GiftModel?) {
        guard let gift = gift else {
            return
        }

        thumbnail.kf.setImage(with: gift.img_path)
        lbShortDesc.setSpacingText(gift.title ?? "")
//        lbDesc.attributedText = gift.detail?.htmlToAttributedString
        lbDesc.setHTMLFromString(htmlText: gift.detail ?? "")
        labelVisible(gift.type != nil)
        setupLabel(gift.isMember)
    }
}
