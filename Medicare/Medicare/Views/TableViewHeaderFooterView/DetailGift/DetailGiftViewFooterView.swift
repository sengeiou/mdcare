//
//  DetailGiftViewFooterView.swift
//  Medicare
//
//  Created by Thuan on 3/20/20.
//

import UIKit

typealias DetailGiftViewFooterViewPresentApply = () -> Void

final class DetailGiftViewFooterView: TSBaseTableViewHeaderFooterView {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbNote: UILabel!
    @IBOutlet fileprivate weak var lbPresentPointTitle: UILabel!
//    @IBOutlet fileprivate weak var lbPresentPointValue: UILabel!
    @IBOutlet fileprivate weak var lbPresentDateTitle: UILabel!
//    @IBOutlet fileprivate weak var lbPresentDateValue: UILabel!
    @IBOutlet fileprivate weak var btnRegister: CommonButton!

    // MARK: Variables

    var presentApply: DetailGiftViewFooterViewPresentApply?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension DetailGiftViewFooterView {

    override func configView() {
        super.configView()

        configLabels()
        configButton()
    }

    fileprivate func configLabels() {
        _ = lbNote.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbPresentPointTitle.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbPresentDateTitle.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configButton() {
        _ = btnRegister.then {
            $0.setTitle("プレゼントに応募する", for: .normal)
        }

        _ = btnRegister.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.presentApply?()
                })
        }
    }
}

extension DetailGiftViewFooterView {

    func setData(_ gift: GiftModel?) {
        guard let gift = gift else {
            return
        }

        lbNote.setSpacingText(gift.notes ?? "")
        if let point = gift.point, point > 0 {
            let value = "\(point)\(R.string.localization.giftStringPoint.localized())"
            let attr = NSMutableAttributedString(string: "応募条件: \(value)")
            attr.setColor(color: ColorName.cCC0D3F.color, forText: "\(value)")
            lbPresentPointTitle.attributedText = attr
        } else {
            let value = "誰でも応募"
            let attr = NSMutableAttributedString(string: "応募条件: \(value)")
            attr.setColor(color: ColorName.cCC0D3F.color, forText: "\(value)")
            lbPresentPointTitle.attributedText = attr
        }
        lbPresentDateTitle.text = "応募期間: \(gift.getPeriod())"
    }
}
