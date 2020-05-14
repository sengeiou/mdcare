//
//  SubscribeMagazineTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 5/5/20.
//

import UIKit
import BEMCheckBox
import Kingfisher

final class SubscribeMagazineTableViewCell: TSBaseTableViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var termView: UIView!
    @IBOutlet fileprivate(set) weak var termButton: UIButton!
    @IBOutlet fileprivate weak var termLabel: UILabel!
    @IBOutlet fileprivate weak var checkBoxView: UIView!
    @IBOutlet fileprivate(set) weak var checkBox: BEMCheckBox!
    @IBOutlet fileprivate weak var checkBoxLabel: UILabel!
    @IBOutlet fileprivate weak var magazineIntroImg: UIImageView!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SubscribeMagazineTableViewCell {

    override func configView() {
        super.configView()

        configTitle()
        configTerms()
        configCheckBox()
    }

    fileprivate func configTitle() {
        _ = lbTitle.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.subscriptionInfoTitle.localized()
        }
    }

    fileprivate func configTerms() {
        _ = termLabel.then {
            $0.font = .regular(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .left
            $0.text = R.string.localization.subscriptionTermNote2.localized()
        }

        let attrTitle = R.string.localization.subscriptionTermNote1.localized()
            .attributeString(configs: [
                .foregroundColor: ColorName.c1390CF.color,
                .underlineStyle: 1.0,
                .font: UIFont.medium(size: 16.0)
            ])
        _ = termButton.then {
            $0.setAttributedTitle(attrTitle, for: .normal)
            $0.contentHorizontalAlignment = .right
        }
    }

    fileprivate func configCheckBox() {
        _ = checkBoxView.then {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = ColorName.black.color.cgColor
        }

        _ = checkBox.then {
            $0.delegate = self
            $0.boxType = .square
            $0.animationDuration = 0.25
            var minimumTouchSize = $0.minimumTouchSize
            minimumTouchSize.width = screenWidth * 2
            $0.minimumTouchSize = minimumTouchSize
        }

        _ = checkBoxLabel.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c333333.color
        }
    }
}

extension SubscribeMagazineTableViewCell {

    func setCheckBox(_ magazineSubscribed: Bool) {
        if magazineSubscribed {
            checkBoxView.layer.borderColor = ColorName.cDF4840.color.cgColor
            checkBoxLabel.textColor = ColorName.cDF4840.color
            checkBoxLabel.text = R.string.localization.subscriptionNoteForSigned.localized()
            checkBox.on = false
            hiddenTermView()
        } else {
            checkBoxView.layer.borderColor = ColorName.black.color.cgColor
            checkBoxLabel.textColor = ColorName.c333333.color
            checkBoxLabel.text = R.string.localization.subscriptionNoteForNotsigned.localized()
            checkBox.on = true
        }
    }

    func setIntroImage(_ url: URL?) {
        guard let url = url else {
            return
        }
        magazineIntroImg.kf.setImage(with: url)
    }

    func hiddenTermView() {
        termView.isHidden = true
        for constraint in termView.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                constraint.constant = 0
                break
            }
        }
    }
}

// MARK: - BEMCheckBoxDelegate

extension SubscribeMagazineTableViewCell: BEMCheckBoxDelegate {

    func animationDidStop(for checkBox: BEMCheckBox) {

    }
}
