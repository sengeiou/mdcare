//
//  UIViewController+NavigationItemExtension.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import UIKit

/** NavigationItemExtension Extends UIViewController
 
 */

enum ItemPosition {
    case left, right
}

enum ItemType {
    case home, myPage, logo, close, back(title: String), language, avatar, search, add
}

extension UIViewController {

    func setNavigationBarButton(items: [(ItemType, ItemPosition)]?,
                                navigationItem: UINavigationItem?,
                                verticalPosition: CGFloat = 0.0) {
        let unwrappedNavigationItem = navigationItem ?? self.navigationItem

        unwrappedNavigationItem.rightBarButtonItems = nil
        unwrappedNavigationItem.leftBarButtonItems = nil

        unwrappedNavigationItem.hidesBackButton = true

        guard let items = items else {
            return
        }

        var rightBarButtonItems = [UIBarButtonItem]()
        var leftBarButtonItems = [UIBarButtonItem]()

        for (type, position) in items {
            let item = createBarButtonItemWith(key: type, position: position)
            guard let guardItem = item else {
                continue
            }

            guardItem.setBackgroundVerticalPositionAdjustment(verticalPosition, for: UIBarMetrics.default)

            switch position {
            case .left:
                leftBarButtonItems.append(guardItem)
            case .right:
                rightBarButtonItems.append(guardItem)
            }
        }

        unwrappedNavigationItem.setLeftBarButtonItems(leftBarButtonItems, animated: false)
        unwrappedNavigationItem.setRightBarButtonItems(rightBarButtonItems, animated: false)
    }

    func createBarButtonItemWith(key: ItemType, position: ItemPosition) -> UIBarButtonItem? {
        var item: UIBarButtonItem?
        switch key {
        case .home:
            item = createCustomButton(with: R.string.localization.buttonHomePageTitle.localized(),
                                      image: R.image.home_page_icon(),
                                      selector: #selector(actionOpenHome),
                                      position: position)
        case .myPage:
            item = createCustomButton(with: R.string.localization.buttonMyPageTitle.localized(),
                                      image: R.image.my_page_icon(),
                                      selector: #selector(actionOpenMyPage),
                                      position: position)
        case .logo:
            item = createLogoBarItemWith(selector: nil)
        case .close:
            item = createBarItemWith(image: nil,
                                     selector: #selector(actionClose))
        case .back(let title):
            item = createCustomButton(with: title,
                                      image: R.image.back(),
                                      selector: #selector(actionBack),
                                      position: position)
        case .language:
            let flagIcon = LanguageCode(rawValue: Localize.currentLanguage())?.flagIcon
            item = createBarItemWith(image: flagIcon?.withRenderingMode(.alwaysOriginal),
                                     selector: #selector(actionChangeLanguage))
        case .avatar:
            let avatarImage = (prefs?.isLoggedIn ?? false) ? R.image.avatar() : R.image.avatar()
            item = createBarItemWith(image: avatarImage?.withRenderingMode(.alwaysOriginal),
                                     selector: #selector(actionViewUserProfile))
        case .search:
            item = createBarItemWith(image: nil,
                                     selector: #selector(actionOpenSearch))
        case .add:
            item = createBarItemWith(image: nil,
                                     selector: #selector(actionAdd))
        }

        return item
    }

    private func createBarItemWith(image: UIImage?,
                                   selector: Selector?,
                                   tintColor: UIColor = ColorName.c333333.color) -> UIBarButtonItem {
        let tempItem = UIBarButtonItem(image: image,
                                       style: .plain,
                                       target: self,
                                       action: selector)
        tempItem.tintColor = tintColor

        return tempItem
    }

    private func createLogoBarItemWith(selector: Selector?,
                                       tintColor: UIColor = ColorName.c333333.color) -> UIBarButtonItem {
        let logoImage = UIImage.image(fromText: "Medicare",
                                      font: .bold(size: 25),
                                      color: tintColor,
                                      maxSize: CGSize(width: 200, height: 30))
        let tempItem = createBarItemWith(image: logoImage.withRenderingMode(.alwaysOriginal),
                                         selector: selector,
                                         tintColor: tintColor).then {
                                            $0.isEnabled = selector != nil
        }

        return tempItem
    }

    private func createCustomButton(with title: String,
                                    image: UIImage?,
                                    selector: Selector,
                                    tintColor: UIColor = ColorName.c333333.color,
                                    position: ItemPosition) -> UIBarButtonItem {
        let button = UIButton(type: .system).then {
            $0.titleLabel?.font = .medium(size: 14)
            $0.tintColor = tintColor
            $0.setTitle(title, for: .normal)
            $0.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.addTarget(self, action: selector, for: .touchUpInside)

            switch position {
            case .left:
                let imageLeftInset: CGFloat = -10
                $0.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imageLeftInset, bottom: 0, right: 0.0)
            case .right:
                let titleRightInset: CGFloat = -10
                $0.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: titleRightInset)
            }
        }
        let customButton = UIBarButtonItem(customView: button)

        return customButton
    }
}

extension UIViewController {

    func setNavigationBarButton(items: [(ItemType, ItemPosition)]?, verticalPosition: CGFloat = 0.0) {
        setNavigationBarButton(items: items, navigationItem: navigationItem, verticalPosition: verticalPosition)
    }

    func hidesBackButton() {
        hidesBackButtonOn(navigationItem: navigationItem)
    }

    private func hidesBackButtonOn(navigationItem: UINavigationItem?) {
        let unwrappedNavigationItem = navigationItem ?? self.navigationItem
        unwrappedNavigationItem.hidesBackButton = true
    }
}

extension UIViewController {

    // MARK: - Actions

    @objc func actionClose() {

    }

    @objc func actionBack() {

    }

    @objc func actionOpenNotification() {

    }

    @objc func actionChangeLanguage() {

    }

    @objc func actionViewUserProfile() {

    }

    @objc func actionOpenSearch() {

    }

    @objc func actionAdd() {

    }

    @objc func actionOpenHome() {

    }

    @objc func actionOpenMyPage() {

    }
}
