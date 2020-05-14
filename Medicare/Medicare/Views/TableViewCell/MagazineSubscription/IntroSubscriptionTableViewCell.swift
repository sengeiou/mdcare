//
//  IntroSubscriptionTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit
import Kingfisher

final class IntroSubscriptionTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate weak var introImageView: UIImageView!
    @IBOutlet fileprivate(set) weak var registerLaterButton: UIButton!

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

        configButtons()
        configImageView()
    }

    private func configButtons() {
        _ = registerLaterButton.then {
            $0.tintColor = ColorName.c1390CF.color
            $0.titleLabel?.font = .medium(size: 16.0)
            $0.setTitle(R.string.localization.registerLater.localized(), for: .normal)
        }
    }

    private func configImageView() {
        _ = introImageView.then {
            $0.contentMode = .scaleAspectFit
            $0.image = R.image.magazineIntro()
        }
    }

    func setIntroImage(_ url: URL?) {
        guard let url = url else {
            return
        }
        introImageView.kf.setImage(with: url)
    }
}
