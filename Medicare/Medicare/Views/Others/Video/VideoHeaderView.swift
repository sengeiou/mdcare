//
//  VideoHeaderView.swift
//  Medicare
//
//  Created by Thuan on 3/9/20.
//

import UIKit
import Kingfisher

final class VideoHeaderView: UIView {

    // MARK: IBOutlets

    @IBOutlet weak var imgChannel: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.clear
        configLabels()
        configImageView()
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbDesc.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 0
        }
    }

    fileprivate func configImageView() {
        _ = imgChannel.then {
            $0.layer.cornerRadius = 15
            $0.masksToBounds = true
        }
    }
}

extension VideoHeaderView {

    func setData(_ item: VideoChannelModel?) {
        imgChannel.kf.setImage(with: item?.img_path)
        lbTitle.text = item?.title
        lbDesc.setSpacingText(item?.desc ?? "")
    }
}
