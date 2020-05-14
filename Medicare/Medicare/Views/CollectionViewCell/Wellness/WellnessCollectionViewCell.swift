//
//  WellnessCollectionViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/2/20.
//

import UIKit
import Cartography
import Kingfisher

final class WellnessCollectionViewCell: TSBaseCollectionViewCell {

    fileprivate let stackView = UIStackView()
    fileprivate let shadowView = UIView()
    fileprivate let thumbImageView = UIImageView()
    fileprivate let playIconImageView = UIImageView()
    fileprivate let titleLabel = UILabel()

    public var isVisiblePlayIcon: Bool = false {
        didSet {
            playIconImageView.isHidden = !isVisiblePlayIcon
        }
    }

    override func configView() {
        super.configView()

        _ = contentView.then {
            $0.backgroundColor = ColorName.white.color
            $0.cornerRadius = 10.0
            $0.dropShadowForMediaThumb()
        }

        configStackView()
        configShadowView()
        configImageViews()
        configTitleLabel()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        constrain(stackView) {
            $0.center == $0.superview!.center
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
        }
    }

    private func configShadowView() {
        _ = shadowView.then {
            /*
            $0.dropShadowForMediaThumb()
            */
            $0.cornerRadius = 10.0
            $0.masksToBounds = true
        }

        stackView.addArrangedSubview(shadowView)
    }

    private func configImageViews() {
        _ = thumbImageView.then {
            $0.contentMode = .scaleAspectFill
            /*
            $0.cornerRadius = 10.0
             */
            $0.masksToBounds = true
        }

        shadowView.addSubview(thumbImageView)
        constrain(thumbImageView) {
            $0.top == $0.superview!.top
            $0.leading == $0.superview!.leading
            $0.centerX == $0.superview!.centerX
        }

        _ = playIconImageView.then {
            $0.contentMode = .center
            $0.image = R.image.playIcon()
        }

        shadowView.addSubview(playIconImageView)
        constrain((playIconImageView)) {
            $0.center == $0.superview!.center
        }

        isVisiblePlayIcon = false
    }

    private func configTitleLabel() {
        _ = titleLabel.then {
            $0.font = .medium(size: 12.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .left
            $0.numberOfLines = 2
        }

        shadowView.addSubview(titleLabel)
        constrain(titleLabel, thumbImageView) {
            $0.leading == $0.superview!.leading + 8.0
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 4.0
            $0.bottom == $0.superview!.bottom - 4.0
            $0.height >= 30.0
        }
    }
}

extension WellnessCollectionViewCell {

    override func configCellWithData(data: Any?) {
        guard let media = data as? MediaProtocol else {
            return
        }

        thumbImageView.kf.setImage(with: media.imageUrl)
        titleLabel.text = media.name
    }
}
