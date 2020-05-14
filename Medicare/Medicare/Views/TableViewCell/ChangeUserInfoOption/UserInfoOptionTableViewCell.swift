//
//  UserInfoOptionTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class UserInfoOptionTableViewCell: ShadowTableViewCell {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var valueLabel: UILabel!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var separatorView: UIView!
    @IBOutlet fileprivate weak var accessoryImageView: UIImageView!
    @IBOutlet fileprivate weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var containerViewBottomConstraint: NSLayoutConstraint!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        selectionStyle = .none
        configContainerView()
        configLabels()
        configAccessoryImageView()
        configSeparatorView()
    }

    private func configContainerView() {
        _ = containerView.then {
            $0.backgroundColor = .clear
        }
    }

    private func configLabels() {
        let labels: [UILabel] = [
            titleLabel,
            valueLabel
        ]
        labels.forEach {
            $0.numberOfLines = 2
        }

        _ = titleLabel.then {
            $0.font = .medium(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .left
        }

        _ = valueLabel.then {
            $0.font = .medium(size: 14.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .right
        }

        _ = infoLabel.then {
            $0.font = .medium(size: 14.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .right
        }
    }

    private func configAccessoryImageView() {
        _ = accessoryImageView.then {
            $0.image = R.image.rightArrow()
            $0.contentMode = .right
        }
    }

    private func configSeparatorView() {
        _ = separatorView.then {
            $0.backgroundColor = ColorName.cDFDFDF.color
        }
    }

    override func setCornerType(_ type: CornerType,
                                cornerPadding: CornerPadding = CornerPadding(x: 5.0, y: 5.0),
                                in tableView: UITableView? = nil) {
        super.setCornerType(type, cornerPadding: cornerPadding, in: tableView)

        switch type {
        case .top:
            containerViewTopConstraint.constant = cornerPadding.y
            containerViewBottomConstraint.constant = 0.0
            separatorView.isHidden = false
        case .bottom:
            containerViewTopConstraint.constant = 0.0
            containerViewBottomConstraint.constant = cornerPadding.y
            separatorView.isHidden = true
        case .all:
            containerViewTopConstraint.constant = cornerPadding.y
            containerViewBottomConstraint.constant = cornerPadding.y
            separatorView.isHidden = true
        default:
            containerViewTopConstraint.constant = 0.0
            containerViewBottomConstraint.constant = 0.0
            separatorView.isHidden = false
        }
    }
}

extension UserInfoOptionTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let (title, value) = data as? (String, String) else {
            return
        }

        titleLabel.text = title
        valueLabel.text = value
    }

    func set(accessoryType: AccessoryType) {
        accessoryImageView.isHidden = accessoryType == .none
    }

    func setInfo(_ userDetail: UserDetailModel?) {
        guard let userDetail = userDetail else {
            infoLabel.text = ""
            return
        }

        if userDetail.magazineSubscribed {
            infoLabel.text = R.string.localization.subscriptionInfoSigned.localized()
        } else {
            infoLabel.text = R.string.localization.subscriptionInfoNotsigned.localized()
        }
    }
}
