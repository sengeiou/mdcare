//
//  TabBarItemContentView.swift
//  Medicare
//
//  Created by sanghv on 6/27/19.
//

import UIKit

final class TabBarItemContentView: ESTabBarItemContentView {

    private var duration = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)

        let normalStateColor = UIColor.lightGray
        let activeStateColor = ColorName.white.color
        textColor = normalStateColor
        highlightTextColor = activeStateColor
        iconColor = normalStateColor
        highlightIconColor = activeStateColor
        imageView.contentMode = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        insets = UIEdgeInsets(top: 4, left: 0, bottom: 6, right: 0)
    }

    convenience init(duration: TimeInterval) {
        self.init()

        self.duration = duration
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateLayout() {
        super.updateLayout()

        titleLabel.font = .regular(size: 11)
    }

    override func badgeChangedAnimation(animated: Bool, completion: (() -> Void)?) {
        super.badgeChangedAnimation(animated: animated, completion: nil)

        notificationAnimation()
    }

    func notificationAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic

        self.badgeView.layer.add(impliesAnimation, forKey: nil)
    }
}
