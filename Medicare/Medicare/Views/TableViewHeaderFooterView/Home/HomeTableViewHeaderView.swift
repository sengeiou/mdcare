//
//  HomeTableViewHeaderView.swift
//  Medicare
//
//  Created by Thuan on 3/10/20.
//

import Foundation

typealias HomeTableViewHeaderViewShowNotify = () -> Void

final class HomeTableViewHeaderView: TSBaseTableViewHeaderFooterView {

    // MARK: IBOutlets

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var widthContainerImgView: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnView: UIButton!

    // MARK: Variables

    var showNotify: HomeTableViewHeaderViewShowNotify?

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func showNotifyAction(_ sender: Any) {
        showNotify?()
    }
}

extension HomeTableViewHeaderView {

    override func configView() {
        super.configView()

        configLabel()
        configButton()
    }

    fileprivate func configLabel() {
        _ = lbTitle.then {
            $0.font = .medium(size: 20)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configButton() {
        _ = btnView.then {
            $0.titleLabel?.font = .medium(size: 14)
            $0.setTitleColor(ColorName.c1390CF.color, for: .normal)
            $0.setTitle(R.string.localization.homeString003.localized(), for: .normal)
            $0.isHidden = true
        }
    }
}

extension HomeTableViewHeaderView {

    func setData(_ section: Int) {
        switch section {
        case HomeSectionType.magazine.rawValue:
            imgView.image = R.image.magazine_tab_icon()
            lbTitle.text = R.string.localization.homeString004.localized()
        case HomeSectionType.video.rawValue:
            imgView.image = R.image.video_tab_icon()
            lbTitle.text = R.string.localization.homeString005.localized()
        case HomeSectionType.gift.rawValue:
            imgView.image = R.image.gift_tab_icon()
            lbTitle.text = R.string.localization.homeString006.localized()
        default:
            break
        }
    }

    private func iconHidden() {
        imgView.isHidden = true
        widthContainerImgView.constant = 0
    }

    private func buttonShow() {
        btnView.isHidden = false
    }
}
