//
//  NotificationListViewController.swift
//  Medicare
//
//  Created by Thuan on 3/7/20.
//

import UIKit
import PullToRefresh

final class NotificationListViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tblView: UITableView!

    // MARK: Variables

    var route: NotificationListRouter?
    fileprivate var p: NotificationListPresenter?
    fileprivate var notifications = [NotificationModel]()
    fileprivate var pageSize = NumberConstant.pageSize
    fileprivate var pageIndex = NumberConstant.startPageIndex
    fileprivate var tempPageIndex = NumberConstant.startPageIndex
    fileprivate var canLoadMore = false

    // MARK: - Initialize

    class func newInstance() -> NotificationListViewController {
        guard let newInstance = R.storyboard.notification.notificationListViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func actionBack() {
        route?.close()
    }
}

extension NotificationListViewController {

    override func configView() {
        super.configView()

        view.backgroundColor = UIColor.white

        route?.viewController = self

        configTableView()

        p = NotificationListPresenter()
        p?.delegate = self
        loadNotifications()
    }

    fileprivate func configTableView() {
        _ = tblView.then {
            $0.register(UINib(nibName: R.nib.notificationTableViewCell.name, bundle: nil),
                            forCellReuseIdentifier: R.reuseIdentifier.notificationTableViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = UIColor.clear
            $0.backgroundColor = UIColor.clear
        }
        extendBottomInsetIfNeed(for: tblView)

        tblView.addPullToRefresh(PullToRefresh()) {
            self.resetPageIndex()
            self.loadNotifications(showHUD: false)
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle("お知らせ")

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

    fileprivate func loadNotifications(showHUD: Bool = true) {
        p?.loadNotifications(pageSize: pageSize, pageIndex: pageIndex, showHUD: showHUD)
    }

    fileprivate func resetPageIndex() {
        pageSize = NumberConstant.pageSize
        pageIndex = NumberConstant.startPageIndex
        tempPageIndex = pageSize
    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.notificationTableViewCellID.identifier,
                        for: indexPath) as? TSBaseTableViewCell else {
                            return UITableViewCell()
        }

        cell.configCellWithData(data: notifications[indexPath.row])
        if let cell = cell as? NotificationTableViewCell {
            cell.setSeparatorViewVisible(!(indexPath.row == notifications.count - 1))
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if canLoadMore {
            tableView.addLoading(indexPath) { [weak self] in
                self?.canLoadMore = false
                self?.tempPageIndex = self?.pageIndex ?? 0
                self?.pageIndex += 1
                self?.loadNotifications(showHUD: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        route?.openNotificationDetailView(notifications[indexPath.row])
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension NotificationListViewController: NotificationListPresenterDelegate {

    func loadNotificationsCompleted(_ notifications: [NotificationModel], error: String?) {
        tblView.endAllRefreshing()
        tblView.stopLoading()
        if error != nil {
            canLoadMore = true
            pageIndex = tempPageIndex
            return

        }
        canLoadMore = !(notifications.count < pageSize)
        if pageIndex == NumberConstant.startPageIndex {
            self.notifications = notifications
        } else {
            self.notifications += notifications
        }
        tblView.reloadData()
    }
}
