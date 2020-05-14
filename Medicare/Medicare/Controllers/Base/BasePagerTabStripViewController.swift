//
//  BasePagerTabStripViewController.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import UIKit
import XLPagerTabStrip

class BasePagerTabStripViewController: ButtonBarPagerTabStripViewController {

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(LCLLanguageChangeNotification),
                                                  object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        styleButtonBarPager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadLocalizedViews),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        setInteractivePopGestureEnabled()
        configView()
        reloadLocalizedViews()
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return tabViewControllers
    }

    var tabViewControllers: [BasePagerViewController] {
        fatalError("Must be overridden by subclass!")
    }
}

extension BasePagerTabStripViewController {

    @objc func configView() {
        configContainerView()
        configButtonBar()
    }

    @objc func configContainerView() {
        _ = containerView?.then {
            $0.bounces = false
            $0.isDirectionalLockEnabled = true
        }
    }

    @objc func configButtonBar() {
        _ = buttonBarView.then {
            $0.bounces = true
            $0.isScrollEnabled = true
            $0.dropShadow(color: ColorName.c333333.color,
                          opacity: 0.5,
                          offSet: CGSize(width: 0, height: 1),
                          radius: 1,
                          scale: true)
        }
    }

    @objc func styleButtonBarPager() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0.0
        settings.style.buttonBarBackgroundColor = ColorName.white.color
        settings.style.buttonBarItemBackgroundColor = ColorName.white.color
        settings.style.selectedBarBackgroundColor = ColorName.c333333.color
        settings.style.buttonBarItemTitleColor = ColorName.c333333.color
        settings.style.buttonBarItemFont = .regular(size: 13.0)
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 16
        settings.style.buttonBarHeight = 40

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?,
            newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat,
            changeCurrentIndex: Bool,
            animated: Bool) -> Void in
            guard let s = self else {
                return
            }

            guard changeCurrentIndex == true else {
                return
            }

            _ = oldCell?.label.then {
                $0.textColor = s.settings.style.buttonBarItemTitleColor
                $0.font = s.settings.style.buttonBarItemFont
            }

            _ = newCell?.label.then {
                $0.textColor = s.settings.style.selectedBarBackgroundColor
                $0.font = .bold(size: 13.0)
            }
        }
    }
}
