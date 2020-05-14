//
//  MyMenuPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol MyMenuViewDelegate: class {
    func didLoadNotifications()
}

final class MyMenuPresenter {

    fileprivate weak var delegate: MyMenuViewDelegate?

    fileprivate let sections = MyMenuSection.allCases
    fileprivate var notifications: [NotificationModel] = []
    fileprivate let menu1 = MyMenuRow1.allCases
    fileprivate let menu2 = MyMenuRow2.allCases

    convenience init(delegate: MyMenuViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: MyMenuViewDelegate) {
        self.delegate = delegate
    }
}

extension MyMenuPresenter {

    func loadNotifications(showHUD: Bool = true) {
        if showHUD {
            showHUDAndAllowUserInteractionEnabled()
        }

        let gateWay = NotificationGateway()
        gateWay.getNotificationList(pageSize: 1, pageIndex: 0, success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let notifications = Mapper<NotificationModel>().mapArray(
                JSONObject: json[ResponseKey.data].arrayObject) else {
                    return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.notifications = notifications

            weakSelf.delegate?.didLoadNotifications()
        }, failure: { (_) in
        })
    }

}

extension MyMenuPresenter {

    var numberOfSections: Int {
        return sections.count
    }

    func sectionTitleAt(section: Int) -> String {
        guard section < numberOfSections else {
            return TSConstants.EMPTY_STRING
        }

        return sections[section].title
    }

    func numberOfRowsAt(section: Int) -> Int {
        let sectionType = MyMenuSection(raw: section)
        switch sectionType {
        case .notification:
            return min(1, numberOfRowsInNotificatons)
        case .menu1:
            return 1
        case .menu2:
            return numberOfRowsInMenu2
        }
    }

    func valueAt(indexPath: IndexPath) -> Any {
        let sectionType = MyMenuSection(raw: indexPath.section)
        switch sectionType {
        case .notification:
            return (notificationTitleAt(row: indexPath.row), TSConstants.EMPTY_STRING)
        case .menu1:
            return itemInMenu1At(row: indexPath.row)
        case .menu2:
            return itemInMenu2At(row: indexPath.row)
        }
    }

    var hasNotificaton: Bool {
        return numberOfRowsInNotificatons > 0
    }

    var numberOfRowsInNotificatons: Int {
        return notifications.count
    }

    func notificationTitleAt(row: Int) -> String {
        let notification = notificationAt(row: row)

        return notification.title ?? TSConstants.EMPTY_STRING
    }

    func notificationAt(row: Int) -> NotificationModel {
        guard row < numberOfRowsInNotificatons else {
            return NotificationModel()
        }

        return notifications[row]
    }

    var numberOfRowsInMenu1: Int {
        return menu1.count
    }

    func itemInMenu1At(row: Int) -> MyMenuRow1 {
        guard row < numberOfRowsInMenu1 else {
            return .point
        }

        return menu1[row]
    }

    private var numberOfRowsInMenu2: Int {
        return menu2.count
    }

    private func itemInMenu2At(row: Int) -> (String, String) {
        guard row < numberOfRowsInMenu2 else {
            return (TSConstants.EMPTY_STRING, TSConstants.EMPTY_STRING)
        }

        let item = menu2[row]
        switch item {
        case .versionInfo:
            guard let appVersion = appVersion,
                let buildVersion = buildVersion else {
                    return (item.title, TSConstants.EMPTY_STRING)
            }

            print(buildVersion)
            return (item.title, appVersion)
            // return (item.title, "\(appVersion) (\(buildVersion))")
        default:
            return (item.title, TSConstants.EMPTY_STRING)
        }
    }
}
