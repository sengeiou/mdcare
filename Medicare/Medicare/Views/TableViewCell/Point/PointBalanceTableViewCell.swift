//
//  PointBalanceTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

protocol PointBalanceTableViewCellDelegate: class {
    func openQRScanner()
}

final class PointBalanceTableViewCell: ShadowTableViewCell {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var pLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var valueLabel: UILabel!
    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var qrCodeButton: CommonButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        selectionStyle = .none
        configContainerView()
        configLabels()
        configQrCodeButton()
    }

    private func configContainerView() {
        _ = containerView.then {
            $0.backgroundColor = ColorName.white.color
            // $0.cornerRadius = 3.0
        }
    }

    private func configLabels() {
        let pLabelWidth = pLabel.bounds.width
        _ = pLabel.then {
            $0.font = .medium(size: 22.0)
            $0.textColor = ColorName.white.color
            $0.textAlignment = .center
            $0.backgroundColor = ColorName.cC4C4C4.color
            $0.text = "P"
            $0.cornerRadius = pLabelWidth/2
            $0.masksToBounds = true
        }

        _ = titleLabel.then {
            $0.font = .medium(size: 16.0)
            $0.textColor = ColorName.c656565.color
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            $0.text = R.string.localization.pointBalance.localized()
        }

        _ = valueLabel.then {
            $0.font = .medium(size: 28.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .right
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }
    }

    private func configQrCodeButton() {
        _ = qrCodeButton.then {
            $0.setTitle(R.string.localization.getPointsFromQrCode.localized(), for: .normal)
            $0.setImage(R.image.qrcode()?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 12.0)
            $0.isHidden = true

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapQrCode()
                })
        }
    }
}

// MARK: - Actions

extension PointBalanceTableViewCell {

    private func didTapQrCode() {
        (delegate as? PointBalanceTableViewCellDelegate)?.openQRScanner()
    }
}

extension PointBalanceTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let value = data as? String else {
            return
        }

        valueLabel.text = value
    }
}
