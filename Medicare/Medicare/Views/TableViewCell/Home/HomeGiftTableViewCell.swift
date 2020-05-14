//
//  HomeGiftTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/6/20.
//

import UIKit
import Kingfisher

final class HomeGiftTableViewCell: TSBaseTableViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var wrapperView: UIView!
    @IBOutlet fileprivate weak var thumbnail: UIImageView!
    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var lbSubTitle: UILabel!
    @IBOutlet fileprivate weak var btnLabel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension HomeGiftTableViewCell {

    override func configView() {
        super.configView()

        selectionStyle = .none
        configLabels()
        configButton()
        configWrapperView()
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbSubTitle.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.c333333.color
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

    fileprivate func configWrapperView() {
        _ = wrapperView.then {
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
            $0.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 2.0
            $0.layer.cornerRadius = 5
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

extension HomeGiftTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let gift = data as? GiftModel else {
            return
        }

        setData(gift)
    }

    fileprivate func setData(_ item: GiftModel) {
        lbTitle.setSpacingText(item.title ?? "")
        lbSubTitle.text = "応募期間: " + item.getPeriod()
        thumbnail.kf.setImage(with: item.img_path)
        labelVisible(item.type != nil)
        setupLabel(item.isMember)
    }
}
