//
//  TextValueTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class TextValueTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var requiredView: UIView!
    @IBOutlet fileprivate(set) weak var requiredLabel: UILabel!
    @IBOutlet fileprivate(set) weak var valueLabel: UILabel!

    public var isRequired: Bool = true {
        didSet {
            requiredView.isHidden = !isRequired
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        configRequiredView()
        configLabels()
    }

    private func configRequiredView() {
        _ = requiredView?.then {
            $0.backgroundColor = ColorName.cE84680.color
            $0.cornerRadius = $0.frame.height / 2
        }
    }

    private func configLabels() {
        _ = titleLabel.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 18.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        _ = requiredLabel.then {
            $0.textColor = ColorName.white.color
            $0.font = .medium(size: 13.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        _ = valueLabel.then {
            $0.textColor = ColorName.c525263.color
            $0.font = .medium(size: 20.0)
            $0.numberOfLines = 0
        }
    }
}
