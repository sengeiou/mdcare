//
//  DetailGiftSupplementaryTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/20/20.
//

import UIKit
import Kingfisher

class DetailGiftSupplementaryTableViewCell: TSBaseTableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var widthThumbnail: NSLayoutConstraint!
    @IBOutlet weak var topPaddingContentLabel: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension DetailGiftSupplementaryTableViewCell {

    override func configView() {
        super.configView()

        selectionStyle = .none
        configLabels()
        configThumbnail()
    }

    fileprivate func configLabels() {
        _ = lbContent.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configThumbnail() {
        _ = thumbnail.then {
            $0.layer.cornerRadius = 10
            $0.masksToBounds = true
        }
    }

    override func configCellWithData(data: Any?) {
        guard let item = data as? GiftSupplementaryModel else {
            return
        }

        setData(item)
    }
}

extension DetailGiftSupplementaryTableViewCell {

    fileprivate func setData(_ item: GiftSupplementaryModel) {
        thumbnail.kf.setImage(with: item.img_path)
//        lbContent.attributedText = item.desc?.htmlToAttributedString
        lbContent.setHTMLFromString(htmlText: item.desc ?? "")

        if item.imageNull && item.contentNull {
            widthThumbnail.constant = 0
            topPaddingContentLabel.constant = 0
        } else if item.imageNull {
            widthThumbnail.constant = 0
            topPaddingContentLabel.constant = 0
        } else if item.contentNull {
            widthThumbnail.constant = (appDelegate?.window?.frame.width ?? 0.0) - 40
            topPaddingContentLabel.constant = 0
        } else {
            widthThumbnail.constant = (appDelegate?.window?.frame.width ?? 0.0) - 40
            topPaddingContentLabel.constant = 15
        }
    }
}
