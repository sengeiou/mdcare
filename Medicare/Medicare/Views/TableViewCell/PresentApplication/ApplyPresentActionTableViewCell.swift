//
//  ApplyPresentActionTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class ApplyPresentActionTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate weak var termsView: UIView!
    @IBOutlet fileprivate(set) weak var termsButton: UIButton!
    @IBOutlet fileprivate weak var termsLabel: UILabel!
    @IBOutlet fileprivate(set) weak var applyButton: CommonButton!

    public var isVisibleTermsView: Bool = true {
        didSet {
            termsView.isHidden = !isVisibleTermsView
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        configTermsLabel()
        configButtons()
    }

    private func configTermsLabel() {
        _ = termsLabel.then {
            $0.font = .regular(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .left
            $0.text = R.string.localization.agreeWith.localized()
        }
    }

    private func configButtons() {
        let attrTitle = R.string.localization.applicationTerms.localized()
            .attributeString(configs: [
                .foregroundColor: ColorName.c1390CF.color,
                .underlineStyle: 1.0,
                .font: UIFont.medium(size: 16.0)
            ])
        _ = termsButton.then {
            $0.setAttributedTitle(attrTitle, for: .normal)
            $0.contentHorizontalAlignment = .right

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapTermsButton()
                })
        }

        _ = applyButton.then {
            $0.setTitle(R.string.localization.applyForAPresent.localized(), for: .normal)

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapApplyButton()
                })
        }
    }

    func setTermsButtonTitle(_ title: String) {
        let attrTitle = title
            .attributeString(configs: [
                .foregroundColor: ColorName.c1390CF.color,
                .underlineStyle: 1.0,
                .font: UIFont.medium(size: 16.0)
            ])
        _ = termsButton.then {
            $0.setAttributedTitle(attrTitle, for: .normal)
        }
    }
}

extension ApplyPresentActionTableViewCell {

    private func didTapTermsButton() {

    }

    private func didTapApplyButton() {

    }
}
