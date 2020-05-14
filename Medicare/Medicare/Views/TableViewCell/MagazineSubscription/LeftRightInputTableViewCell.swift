//
//  LeftRightInputTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class LeftRightInputTableViewCell: RequiredValueTableViewCell {

    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var requiredView: UIView!
    @IBOutlet fileprivate(set) weak var requiredLabel: UILabel!

    public var isRequired: Bool = true {
        didSet {
            requiredView.isHidden = !isRequired
        }
    }

    public var isKatakanaNameInput: Bool = false

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

        configRequiredView()
        configLabels()
        configTextFields()
    }

    private func configRequiredView() {
        _ = requiredView?.then {
            $0.backgroundColor = ColorName.cE84680.color
            $0.cornerRadius = $0.frame.height / 2
        }
    }

    private func configLabels() {
        _ = titleLabel.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 18.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        _ = requiredLabel.then {
            $0.textColor = ColorName.white.color
            $0.font = .medium(size: 13.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }
    }

    private func configTextFields() {
        let textFields: [UITextField] = [
            leftTextField,
            rightTextField
        ]

        textFields.forEach {
            $0.textColor = ColorName.c333333.color
            $0.font = .regular(size: 16.0)
        }
    }

    override var isLeftTextEmpty: Bool {
        var isLeftTextEmpty = super.isLeftTextEmpty
        if isKatakanaNameInput {
            let invalidValue = !(leftTextField?.text?.trim().isKatakana ?? false)
            isLeftTextEmpty = isLeftTextEmpty || invalidValue
        }

        return isLeftTextEmpty
    }

    override var isRightTextEmpty: Bool {
        var isRightTextEmpty = super.isRightTextEmpty
        if isKatakanaNameInput {
            let invalidValue = !(rightTextField?.text?.trim().isKatakana ?? false)
            isRightTextEmpty = isRightTextEmpty || invalidValue
        }

        return isRightTextEmpty
    }
}
