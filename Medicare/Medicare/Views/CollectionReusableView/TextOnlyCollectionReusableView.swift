//
//  TextOnlyCollectionReusableView.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class TextOnlyCollectionReusableView: TSBaseCollectionReusableView {

    fileprivate let valueLabel = UILabel()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            valueLabel
        ])

        return stackView
    }()

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

        addSubview(stackView)
        addConstraints(withFormat: "H:|-12@750-[v0]-12-|", views: stackView)
        addConstraints(withFormat: "V:|-4@750-[v0(>=50)]-4-|", views: stackView)
    }

    private func configLabels() {
        _ = valueLabel.then {
            $0.font = .medium(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 2
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }
    }
}

extension TextOnlyCollectionReusableView {

    override func configHeaderWithData(data: Any?) {
        guard let text = data as? String else {
            return
        }

        valueLabel.attributedText = text.attributeString(configs: lineHeightConfig(1.33, alignment: .left))
    }
}
