//
//  NotificationTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 4/1/20.
//

import UIKit

final class NotificationTableViewCell: TSBaseTableViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbTime: UILabel!
    @IBOutlet fileprivate weak var lbValue: UILabel!
    @IBOutlet fileprivate weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
}

extension NotificationTableViewCell {

    override func configView() {
        super.configView()

        selectionStyle = .none
        configLabels()
    }

    fileprivate func configLabels() {
        _ = lbTime.then {
            $0.font = .regular(size: 14)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbValue.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }
}

extension NotificationTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let item = data as? NotificationModel else {
            return
        }

        setData(item)
    }

    fileprivate func setData(_ item: NotificationModel) {
        lbTime.text = item.time
        lbValue.text = item.title
    }

    func setSeparatorViewVisible(_ visible: Bool) {
        separatorView.isHidden = !visible
    }
}
