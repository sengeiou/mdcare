//
//  SubscriptionInfoTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 5/5/20.
//

import UIKit

final class SubscriptionInfoTableViewCell: TSBaseTableViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var lbValue: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SubscriptionInfoTableViewCell {

    override func configView() {
        super.configView()

        configLabels()
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c525263.color
            $0.text = R.string.localization.subscriptionInfoTitle.localized()
        }

        _ = lbValue.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c525263.color
        }
    }
}

extension SubscriptionInfoTableViewCell {

    func setSubscriptionValue(isRegistration: Bool) {
        if isRegistration {
            lbValue.text = R.string.localization.subscriptionApplyTitle.localized()
        } else {
            lbValue.text = R.string.localization.subscriptionCancelTitle.localized()
        }
    }
}
