//
//  CategorySettingCollectionFooterView.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

protocol CategorySettingCollectionFooterViewDelegate: class {
    func didTapActionButton()
}

final class CategorySettingCollectionFooterView: TSBaseCollectionReusableView {

    fileprivate let actionButton = CommonButton(
        type: .system,
        frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: 50))
    )
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            actionButton
        ])

        return stackView
    }()

    class var size: CGSize {
        return CGSize(width: 0.0, height: 157)
    }

    override func configView() {
        super.configView()

        configStackView()
        configActionButton()
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
        addConstraints(withFormat: "V:[v0(50)]-20-|", views: stackView)
    }

    private func configActionButton() {
        _ = actionButton.then {
            $0.setTitle(R.string.localization.register.localized(), for: .normal)

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapActionButton()
                })
        }
    }
}

extension CategorySettingCollectionFooterView {

    private func didTapActionButton() {
        (delegate as? CategorySettingCollectionFooterViewDelegate)?.didTapActionButton()
    }
}
