//
//  TabBarController.swift
//  Medicare
//
//  Created by sanghv on 6/27/19.
//

import UIKit

final class TabBarController: ESTabBarController {

    // MARK: Variables

    fileprivate var destinationIndex = 0
    fileprivate var isHomePage: Bool {
        return ShareManager.shared.currentHomePage
    }
    fileprivate var isFirstAppearance: Bool = true
    fileprivate let titleAttributes = [
        NSAttributedString.Key.font: UIFont.medium(size: 12),
        NSAttributedString.Key.foregroundColor: ColorName.dark7.color
    ]

    fileprivate let selectedTitleAttributes = [
        NSAttributedString.Key.font: UIFont.medium(size: 12),
        NSAttributedString.Key.foregroundColor: ColorName.c008DDC.color
    ]

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(LCLLanguageChangeNotification),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(StringConstant.reloadTabBarNotification),
                                                  object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadLocalizedViews),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTabBar),
                                               name: NSNotification.Name(StringConstant.reloadTabBarNotification),
                                               object: nil)

        configView()
        checkAppVersionSetting()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Force selectedIndex at home
        if isFirstAppearance {
            isFirstAppearance = false
//            selectedIndex = TabBarItemType.magazine.rawValue
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigateToTargetScreen()
    }
}

extension TabBarController {

    override var selectedIndex: Int {
        willSet {
            popToRootAtSelectedViewController()
        }
    }

    func popToRootAtSelectedViewController() {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return
        }

        guard navigationController.viewControllers.count > 1 else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            navigationController.popToRootViewController(animated: false)
        }
    }
}

extension TabBarController {

    private func configView() {
        /*
        if let tabBar = tabBar as? ESTabBar {
            tabBar.barTintColor = ColorName.c333333.color
            tabBar.itemCustomPositioning = .centered
            tabBar.shadowImage = UIImage(color: ColorName.c333333.color, size: CGSize(width: screenWidth, height: 0.25))
        }
        */

        tabBar.isTranslucent = true
        tabBar.backgroundColor = UIColor.white
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        tabBar.layer.shadowRadius = 4.0
        tabBar.layer.shadowOpacity = 1.0

        createHomePageTabBar()
    }

    override func reloadLocalizedViews() {
        self.viewControllers?.forEach({ (tabVC) in
            var vc = tabVC
            if let tabVC = tabVC as? UINavigationController {
                vc = tabVC.topViewController ?? vc
            }

//            if vc is ComingSoonViewController {
//                vc.tabBarItem.title = TabBarItemType.home.title
//            } else if vc is ComingSoonViewController {
//                vc.tabBarItem.title = TabBarItemType.home2.title
//            } else if vc is ComingSoonViewController {
//                vc.tabBarItem.title = TabBarItemType.home3.title
//            } else if vc is ComingSoonViewController {
//                vc.tabBarItem.title = TabBarItemType.home4.title
//            } else if vc is ComingSoonViewController {
//                vc.tabBarItem.title = TabBarItemType.home5.title
//            }
        })
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if isHomePage {
            destinationIndex = item.tag
            createMainTabBar()
        } else {
            super.tabBar(tabBar, didSelect: item)
        }
    }
}

// MARK: - Rotation

extension TabBarController {

    override public var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .all
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .unknown
    }
}

extension TabBarController {

    fileprivate func updateView(hightlighted: Bool) {
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes(titleAttributes, for: .normal)
        appearance.setTitleTextAttributes(hightlighted ? selectedTitleAttributes : titleAttributes, for: .selected)
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)

        if #available(iOS 13.0, *) {
            let stand = tabBar.standardAppearance
            stand.stackedLayoutAppearance.normal.titleTextAttributes = titleAttributes
            stand.stackedLayoutAppearance.selected.titleTextAttributes =
                hightlighted ? selectedTitleAttributes : titleAttributes
            stand.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
            stand.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
            stand.shadowImage = UIImage()
            stand.backgroundImage = UIImage()
            stand.shadowColor = .clear
            tabBar.standardAppearance = stand
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }

    fileprivate func createTabBarItem(title: String, image: UIImage?, selected: UIImage?, tag: Int) -> UITabBarItem {
        let item = UITabBarItem(title: title,
                                image: image?.withRenderingMode(.alwaysOriginal),
                                tag: tag)
        item.selectedImage = selected?.withRenderingMode(.alwaysOriginal)
        return item
    }

    fileprivate func createHomePageTabBar() {
        updateView(hightlighted: false)
        let home  = HomeViewController.newInstance()
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.setNavigationBarHidden(false, animated: false)
        homeNav.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString001.localized(),
                                               image: R.image.magazine_tab_icon(),
                                               selected: R.image.magazine_tab_icon(),
                                               tag: TabBarItemType.magazine.rawValue)

        let gift = UIViewController()
        gift.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString002.localized(),
                                              image: R.image.gift_tab_icon(),
                                              selected: R.image.gift_tab_icon(),
                                              tag: TabBarItemType.present.rawValue)

        let health = UIViewController()
        health.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString003.localized(),
                                               image: R.image.health_tab_icon(),
                                               selected: R.image.health_tab_icon(),
                                               tag: TabBarItemType.shopping.rawValue)

        let video = UIViewController()
        video.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString004.localized(),
                                            image: R.image.video_tab_icon(),
                                            selected: R.image.video_tab_icon(),
                                            tag: TabBarItemType.video.rawValue)

        viewControllers = [homeNav, gift, health, video]
        selectedIndex = TabBarItemType.magazine.rawValue
        destinationIndex = selectedIndex
    }

    fileprivate func createMainTabBar() {
        updateView(hightlighted: true)
        ShareManager.shared.currentHomePage = false

        let magazine = MagazineViewController.newInstance()
        let magazineNav = UINavigationController(rootViewController: magazine)
        magazineNav.setNavigationBarHidden(false, animated: false)
        magazineNav.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString001.localized(),
                                               image: R.image.magazine_tab_icon(),
                                               selected: R.image.magazine_tab_selected_icon(),
                                               tag: TabBarItemType.magazine.rawValue)

        let gift = GiftViewController.newInstance()
        let giftNav = UINavigationController(rootViewController: gift)
        giftNav.setNavigationBarHidden(false, animated: false)
        giftNav.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString002.localized(),
                                              image: R.image.gift_tab_icon(),
                                              selected: R.image.gift_tab_selected_icon(),
                                              tag: TabBarItemType.present.rawValue)

        let health = WellnessViewController.newInstance()
        let healthNav = UINavigationController(rootViewController: health)
        healthNav.setNavigationBarHidden(false, animated: false)
        healthNav.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString003.localized(),
                                                image: R.image.health_tab_icon(),
                                                selected: R.image.health_tab_selected_icon(),
                                                tag: TabBarItemType.shopping.rawValue)

        let video = VideoViewController.newInstance()
        let videoNav = UINavigationController(rootViewController: video)
        videoNav.setNavigationBarHidden(false, animated: false)
        videoNav.tabBarItem = createTabBarItem(title: R.string.localization.tabBarString004.localized(),
                                            image: R.image.video_tab_icon(),
                                            selected: R.image.video_tab_selected_icon(),
                                            tag: TabBarItemType.video.rawValue)

        viewControllers = [magazineNav, giftNav, healthNav, videoNav]
        selectedIndex = destinationIndex
    }

    @objc func reloadTabBar() {
        createHomePageTabBar()
    }
}

extension TabBarController {

    private func checkAppVersionSetting() {

    }
}

extension TabBarController {

    private func navigateToTargetScreen() {
        if appDelegate?.openFromPush ?? false {
            openNotificationList()
        }
    }
}

extension TabBarController {

    func openNotificationList() {
        if let selectedView = self.selectedViewController as? UINavigationController,
            let topView = selectedView.visibleViewController as? BaseViewController {
//            topView.openNotificationList()
            topView.actionOpenHome()
        }
    }
}
