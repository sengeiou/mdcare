//
//  IntroActionTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class IntroActionTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate(set) weak var termsButton: UIButton!
    @IBOutlet fileprivate(set) weak var agreeButton: CommonButton!

    public var isVisibleTermsView: Bool = true {
        didSet {
            termsButton.isHidden = !isVisibleTermsView
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

        configButtons()
    }

    private func configButtons() {
        let attrTitle = R.string.localization.notesOnSubscription.localized()
            .attributeString(configs: [
                .foregroundColor: ColorName.c1390CF.color,
                .underlineStyle: 1.0,
                .font: UIFont.medium(size: 16.0)
            ])
        _ = termsButton.then {
            $0.setAttributedTitle(attrTitle, for: .normal)

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

        _ = agreeButton.then {
            $0.setTitle(R.string.localization.agreeToTheAboveAndRegister.localized(), for: .normal)

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapAgreeButton()
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

extension IntroActionTableViewCell {

    private func didTapTermsButton() {

    }

    private func didTapAgreeButton() {

    }
}
