//
//  NotificationListPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

protocol NotificationListPresenterDelegate: class {
    func loadNotificationsCompleted(_ notifications: [NotificationModel], error: String?)
}

final class NotificationListPresenter {

    weak var delegate: NotificationListPresenterDelegate?

    func loadNotifications(pageSize: Int, pageIndex: Int, showHUD: Bool = true) {
        if showHUD {
            showHUDActivity()
        }
        let gateWay = NotificationGateway()
        gateWay.getNotificationList(pageSize: pageSize, pageIndex: pageIndex, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let items = Mapper<NotificationModel>().mapArray(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.loadNotificationsCompleted(items ?? [], error: nil)
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.loadNotificationsCompleted([], error: error)
        })
    }
}
