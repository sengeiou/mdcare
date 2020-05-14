//
//  PointHistoryTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class PointHistoryTableViewCell: ShadowTableViewCell {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var valueLabel: UILabel!
    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var separatorView: UIView!
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
        configSeparatorView()
    }

    private func configContainerView() {
        _ = containerView.then {
            $0.backgroundColor = ColorName.white.color
        }
    }

    private func configLabels() {
        let labels: [UILabel] = [
            titleLabel,
            valueLabel
        ]
        labels.forEach {
            $0.font = .regular(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 2
        }

        _ = titleLabel.then {
            $0.textAlignment = .left
        }

        _ = valueLabel.then {
            $0.textAlignment = .right
        }
    }

    private func configSeparatorView() {
        _ = separatorView.then {
            $0.backgroundColor = ColorName.cDFDFDF.color
            $0.isHidden = true
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

extension PointHistoryTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let (titleAttr, valueAttr) = data as? (NSAttributedString, NSAttributedString) else {
            return
        }

        titleLabel.attributedText = titleAttr
        valueLabel.attributedText = valueAttr
    }
}
