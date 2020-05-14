//
//  TitleAndValueTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class TitleAndValueTableViewCell: TSBaseTableViewCell {

    fileprivate let titleLabel = UILabel()
    fileprivate let valueLabel = UILabel()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            valueLabel
        ])

        return stackView
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        configStackView()
        configLabels()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.alignment = .fill
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        contentView.addConstraints(withFormat: "H:|-28@750-[v0]-28-|", views: stackView)
        contentView.addConstraints(withFormat: "V:|-16@750-[v0(>=24)]-16-|", views: stackView)
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
}

extension TitleAndValueTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let (titleAttr, valueAttr) = data as? (NSAttributedString, NSAttributedString) else {
            return
        }

        titleLabel.attributedText = titleAttr
        valueLabel.attributedText = valueAttr
    }
}
