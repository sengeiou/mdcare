//
//  AnswerCheckboxTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit
import BEMCheckBox

final class AnswerCheckboxTableViewCell: TSBaseTableViewCell {

    fileprivate let checkBox = BEMCheckBox()
    fileprivate let titleLabel = UILabel()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkBox,
            titleLabel
        ])

        return stackView
    }()

    fileprivate weak var answer: AnswerModel?

    weak var checkBoxGroup: BEMCheckBoxGroup? {
        didSet {
            addCheckBoxToGroup()
        }
    }

    public var isVisibleCheckBox: Bool = true {
        didSet {
            checkBox.isHidden = !isVisibleCheckBox
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        accessoryType = .none
        selectionStyle = .none
        configStackView()
        configTitleLabel()
        configCheckBox()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.alignment = .center
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        contentView.addConstraints(withFormat: "H:|-8-[v0]-8-|", views: stackView)
        contentView.addConstraints(withFormat: "V:|-4@750-[v0(>=25)]-4-|", views: stackView)
    }

    private func configCheckBox() {
        _ = checkBox.then {
            $0.delegate = self
            $0.boxType = .square
            $0.animationDuration = 0.25
            var minimumTouchSize = $0.minimumTouchSize
            minimumTouchSize.width = screenWidth * 2
            $0.minimumTouchSize = minimumTouchSize
        }

        checkBox.addConstraints(withFormat: "H:[v0(20)]", views: checkBox)
        checkBox.addConstraints(withFormat: "V:[v0(20)]", views: checkBox)
    }

    private func configTitleLabel() {
        _ = titleLabel.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 16.0)
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }
    }

    private func addCheckBoxToGroup() {
        guard let checkBoxGroup = checkBoxGroup else {
            return
        }

        guard !checkBoxGroup.checkBoxes.contains(checkBoxGroup) else {
            return
        }

        checkBoxGroup.addCheckBox(toGroup: checkBox)
    }
}

// MARK: - BEMCheckBoxDelegate

extension AnswerCheckboxTableViewCell: BEMCheckBoxDelegate {

    func animationDidStop(for checkBox: BEMCheckBox) {
        answer?.selected = checkBox.on
    }
}

extension AnswerCheckboxTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let (title, selected) = data as? (String, Bool) else {
            return
        }

        titleLabel.text = title
        checkBox.on = selected
    }

    func setAnswer(_ answer: AnswerModel) {
        self.answer = answer
    }
}
