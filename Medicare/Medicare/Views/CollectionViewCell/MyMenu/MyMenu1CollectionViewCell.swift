//
//  MyMenu1CollectionViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/2/20.
//

import UIKit
import Cartography

final class MyMenu1CollectionViewCell: TSBaseCollectionViewCell {

    fileprivate let stackView = UIStackView()
    fileprivate let iconImageView = UIImageView()
    fileprivate let titleLabel = UILabel()

    override func configView() {
        super.configView()

        contentView.backgroundColor = ColorName.white.color
        configStackView()
        configIconImageView()
        configTitleLabel()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .fillProportionally
        }

        contentView.addSubview(stackView)
        constrain(stackView) {
            $0.center == $0.superview!.center
            $0.leading == $0.superview!.leading
        }
    }

    private func configIconImageView() {
        _ = iconImageView.then {
            $0.contentMode = .bottom
        }

        stackView.addArrangedSubview(iconImageView)
    }

    private func configTitleLabel() {
        _ = titleLabel.then {
            $0.font = .bold(size: 15.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }

        stackView.addArrangedSubview(titleLabel)
    }
}

extension MyMenu1CollectionViewCell {

    override func configCellWithData(data: Any?) {
        guard let menuItem = data as? MyMenuRow1 else {
            return
        }

        iconImageView.image = menuItem.icon
        titleLabel.text = menuItem.title
    }
}
