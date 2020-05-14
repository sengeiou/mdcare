//
//  RequiredValueTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

class RequiredValueTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate(set) weak var leftTextField: UITextField!
    @IBOutlet fileprivate(set) weak var rightTextField: UITextField!
    fileprivate let errorLabel = UILabel()

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

        configStackView()
        configErrorLabel()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.spacing = 8.0
        }
    }

    private func configErrorLabel() {
        _ = errorLabel.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.cCC0D3F.color
            $0.numberOfLines = 2
            $0.text = nil
            $0.isHidden = true
        }

        stackView.addArrangedSubview(errorLabel)
    }

    var isLeftTextEmpty: Bool {
        return leftTextField?.text?.trim().isEmpty ?? true
    }

    var isRightTextEmpty: Bool {
        return rightTextField?.text?.trim().isEmpty ?? true
    }
}

extension RequiredValueTableViewCell {

    func setError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = message?.isEmpty ?? true

        changeFieldBackgroundColorFor(message)
    }

    private func changeFieldBackgroundColorFor(_ message: String?) {
        let hasError = message != nil
        let errorColor = ColorName.cFFE9F1.color
        let noErrorColor = ColorName.white.color

        leftTextField?.backgroundColor = hasError && isLeftTextEmpty ? errorColor : noErrorColor
        rightTextField?.backgroundColor = hasError && isRightTextEmpty ? errorColor : noErrorColor
    }
}
