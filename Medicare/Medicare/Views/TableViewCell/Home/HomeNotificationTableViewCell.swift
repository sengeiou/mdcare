//
//  HomeNotificationTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/5/20.
//

import UIKit

final class HomeNotificationTableViewCell: ShadowTableViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbValue: UILabel!
    @IBOutlet fileprivate weak var separatorBottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
}

extension HomeNotificationTableViewCell {

    override func configView() {
        super.configView()

        configLabels()
    }

    fileprivate func configLabels() {
        _ = lbValue.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }
}

extension HomeNotificationTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let item = data as? NotificationModel else {
            return
        }

        setData(item)
    }

    fileprivate func setData(_ item: NotificationModel) {
        lbValue.text = item.title
    }

    func separatorViewVisible(_ visible: Bool) {
        separatorBottomView.isHidden = !visible
    }
}
