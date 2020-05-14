//
//  TextOnlyCollectionViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class TextOnlyCollectionViewCell: TSBaseCollectionViewCell {

    fileprivate let valueLabel = UILabel()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            valueLabel
        ])

        return stackView
    }()

    override func configView() {
        super.configView()

        _ = contentView.then {
            backgroundColor = ColorName.white.color
            $0.cornerRadius = 3.0
            $0.masksToBounds = true
            $0.borderWidth = 1.0
            $0.borderColor = ColorName.cCCCCCC.color
        }

        configStackView()
        configLabels()
    }

    override var isSelected: Bool {
        didSet {
            _ = contentView.then {
                $0.backgroundColor = isSelected ? ColorName.cFFCCDE.color : ColorName.white.color
                $0.borderColor = isSelected ? ColorName.cFFCCDE.color : ColorName.cCCCCCC.color
            }
            valueLabel.textColor = isSelected ? ColorName.c333333.color : ColorName.cCCCCCC.color
        }
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.alignment = .fill
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        contentView.addConstraints(withFormat: "H:|-4@750-[v0]-4-|", views: stackView)
        contentView.addConstraints(withFormat: "V:|-4@750-[v0]-4-|", views: stackView)
    }

    private func configLabels() {
        _ = valueLabel.then {
            $0.font = .medium(size: 16.0)
            $0.textColor = ColorName.cCCCCCC.color
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }
    }
}

extension TextOnlyCollectionViewCell {

    override func configCellWithData(data: Any?) {
        guard let text = data as? String else {
            return
        }

        valueLabel.text = text
    }
}
