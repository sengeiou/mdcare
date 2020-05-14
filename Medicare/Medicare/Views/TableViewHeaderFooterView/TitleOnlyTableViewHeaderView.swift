//
//  TitleOnlyTableViewHeaderView.swift
//  Medicare
//
//  Created by sanghv on 1/1/20.
//

import UIKit
import Cartography

protocol TitleOnlyTableViewHeaderViewDelegate: class {
    func showMoreAt(_ section: Int)
}

final class TitleOnlyTableViewHeaderView: TSBaseTableViewHeaderFooterView {

    fileprivate let imageView: UIImageView = UIImageView()
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let flexibleView: UIView = UIView()
    fileprivate let moreButton: UIButton = UIButton(type: .system)
    fileprivate weak var stackViewLeadingConstraint: NSLayoutConstraint?
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            flexibleView,
            moreButton
        ])

        return stackView
    }()

    var isVisibleMoreButton: Bool = false {
        didSet {
            moreButton.isHidden = !isVisibleMoreButton
            flexibleView.isHidden = !isVisibleMoreButton
        }
    }

    override func configView() {
        super.configView()

        configStackView()
        configImageView()
        configTitleLabel()
        configMoreButton()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.alignment = .fill
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        let defaultPadding: CGFloat = 8.0
        constrain(stackView) {
            stackViewLeadingConstraint = (
                $0.leading == $0.superview!.leading + defaultPadding
            )
            $0.top == $0.superview!.top + defaultPadding
            $0.center == $0.superview!.center
        }
    }

    private func configTitleLabel() {
        _ = titleLabel.then {
            $0.font = .medium(size: 20.0)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 2
        }
    }

    private func configImageView() {
        _ = imageView.then {
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }

        constrain(imageView) {
            $0.width == 25
        }
    }

    private func configMoreButton() {
        _ = moreButton.then {
            $0.titleLabel?.font = .bold(size: 14.0)
            $0.setTitle(R.string.localization.viewAll.localized(), for: .normal)
            $0.setTitleColor(ColorName.c1390CF.color, for: .normal)
        }

        isVisibleMoreButton = false

        _ = moreButton.rx.tap
            .takeUntil(moreButton.rx.deallocated)
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {
                    return
                }

                weakSelf.showMore()
            })
    }

    private func showMore() {
        guard let section = section else {
            return
        }

        (delegate as? TitleOnlyTableViewHeaderViewDelegate)?.showMoreAt(section)
    }
}

extension TitleOnlyTableViewHeaderView {

    override func configHeaderWithData(data: Any?) {
        titleLabel.text = data as? String
    }

    func setHorirontalPadding(_ padding: CGFloat) {
        stackViewLeadingConstraint?.constant = padding
    }

    func setImage(_ image: UIImage?) {
        imageView.isHidden = (image == nil)
        imageView.image = image
    }
}
