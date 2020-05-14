//
//  IntroRegisterNowTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class IntroRegisterNowTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate weak var valueLabel: UILabel!

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

        configValueLabel()
    }

    private func configValueLabel() {
        _ = valueLabel.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 16.0)
            $0.numberOfLines = 2
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            $0.attributedText = R.string.localization
                .registerNowUsingTheFormBelow.localized()
                .attributeString(configs: lineHeightConfig(1.5, alignment: .center))
        }
    }
}
