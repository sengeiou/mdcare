//
//  LeftInputRightButtonTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class LeftInputRightButtonTableViewCell: RequiredValueTableViewCell {

    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var requiredView: UIView!
    @IBOutlet fileprivate(set) weak var requiredLabel: UILabel!
    @IBOutlet fileprivate(set) weak var actionButton: UIButton!

    public var isRequired: Bool = true {
        didSet {
            requiredView.isHidden = !isRequired
        }
    }

    public var isVisibleActionButton: Bool = false {
        didSet {
            actionButton.isUserInteractionEnabled = isVisibleActionButton
            actionButton.alpha = isVisibleActionButton ? 1 : 0
        }
    }

    public var isZipcodeInput: Bool = false

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
        configActionButton()
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
            leftTextField
        ]

        textFields.forEach {
            $0.textColor = ColorName.c333333.color
            $0.font = .regular(size: 16.0)
        }
    }

    private func configActionButton() {
        _ = actionButton.then {
            $0.tintColor = ColorName.c1390CF.color
            $0.titleLabel?.font = .medium(size: 16.0)
        }

        isVisibleActionButton = false
    }

    override var isLeftTextEmpty: Bool {
        var isLeftTextEmpty = super.isLeftTextEmpty
        if isZipcodeInput {
            let invalidValue = (leftTextField?.text?.trim().count ?? 0) < NumberConstant.zipcodeLength
            isLeftTextEmpty = isLeftTextEmpty || invalidValue
        }

        return isLeftTextEmpty
    }
}

extension LeftInputRightButtonTableViewCell {

}
