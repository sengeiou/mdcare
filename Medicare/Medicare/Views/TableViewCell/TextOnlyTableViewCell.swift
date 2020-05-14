//
//  TextOnlyTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit
import SkeletonView

final class TextOnlyTableViewCell: TSBaseTableViewCell {

    fileprivate let valueLabel = UILabel()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            valueLabel
        ])

        return stackView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        showAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        isSkeletonable = true
        contentView.isSkeletonable = true
        configStackView()
        configLabels()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.isSkeletonable = true
        }

        contentView.addSubview(stackView)
        contentView.addConstraints(withFormat: "H:|-8@750-[v0]-8-|", views: stackView)
        contentView.addConstraints(withFormat: "V:|-4@750-[v0(>=30)]-4-|", views: stackView)
    }

    private func configLabels() {
        let labels: [UILabel] = [
            valueLabel
        ]
        labels.forEach {
            $0.font = .regular(size: 14.0)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 0
            $0.isSkeletonable = true
        }

        _ = valueLabel.then {
            $0.textAlignment = .left
        }
    }

    private func showAnimation() {
        let labels: [UILabel] = [
            valueLabel
        ]
        labels.forEach {
            $0.showAnimatedSkeleton()
        }
    }

    private func hideAnimation() {
        let labels: [UILabel] = [
            valueLabel
        ]
        labels.forEach {
            $0.hideSkeleton()
        }
    }
}

extension TextOnlyTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let text = data as? String else {
            return
        }

        let shouldHideAnimation = !text.isEmpty
        if shouldHideAnimation {
            hideAnimation()
        }

        valueLabel.text = text
    }
}
