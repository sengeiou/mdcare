//
//  VideoChannelCollectionViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/17/20.
//

import UIKit
import Kingfisher

final class VideoChannelCollectionViewCell: TSBaseCollectionViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var imgChannel: UIImageView!
    @IBOutlet fileprivate weak var lbChannel: UILabel!
    @IBOutlet fileprivate weak var separatorTopView: UIView!
    @IBOutlet fileprivate weak var separatorBottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    fileprivate func configLabel() {
        _ = lbChannel.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configImageView() {
        _ = imgChannel.then {
            $0.layer.cornerRadius = 15
            $0.masksToBounds = true
        }
    }
}

extension VideoChannelCollectionViewCell {

    override func configView() {
        super.configView()

        backgroundColor = UIColor.white
        configLabel()
        configImageView()
    }

    override func configCellWithData(data: Any?) {
        guard let item = data as? VideoChannelModel else {
            return
        }
        setData(item)
    }

    fileprivate func setData(_ item: VideoChannelModel) {
        imgChannel.kf.setImage(with: item.img_path)
        lbChannel.text = item.title
    }

    func separatorBottomViewVisible(_ visible: Bool) {
        separatorBottomView.isHidden = !visible
    }

    func hiddenAllSeparator() {
        separatorTopView.isHidden = true
        separatorBottomView.isHidden = true
    }
}
