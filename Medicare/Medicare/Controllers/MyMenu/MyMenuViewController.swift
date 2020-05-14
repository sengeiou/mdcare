//
//  MyMenuViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class MyMenuViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var tableView: UITableView!

    // MARK: - Variable

    fileprivate let presenter = MyMenuPresenter()
    fileprivate var router = MyMenuRouter()

    // MARK: - Initialize

    class func newInstance() -> MyMenuViewController {
        guard let newInstance = R.storyboard.myMenu.myMenuViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        dismissHUD()
        super.viewWillDisappear(animated)
    }

    func set(router: MyMenuRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.loadNotifications()
    }
}

extension MyMenuViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configTableView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.myPage.localized()

        setNavigationBarButton(items: [
            (.home, .left)
        ])
    }

    private func configTableView() {
        _ = tableView.then {
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = view.backgroundColor
            $0.separatorStyle = .singleLine
            $0.separatorInset = .zero
            $0.estimatedSectionHeaderHeight = 80
            $0.estimatedRowHeight = 80
            $0.rowHeight = UITableView.automaticDimension
            $0.sectionFooterHeight = NumberConstant.minHeaderHeightForGroupedTable
        }
        extendBottomInsetIfNeed(for: tableView)

        _ = tableView.then {
            $0.register(TitleOnlyTableViewHeaderView.self,
                        forHeaderFooterViewReuseIdentifier: TitleOnlyTableViewHeaderView.identifier)
            $0.register(MyMenu1TableViewCell.self,
                        forCellReuseIdentifier: MyMenu1TableViewCell.identifier)
            $0.register(UINib(resource: R.nib.myMenu2TableViewCell),
                        forCellReuseIdentifier: MyMenu2TableViewCell.identifier)
        }
    }
}

// MARK: - Actions

extension MyMenuViewController {

    private func openNotification(row: Int) {
        let notification = presenter.notificationAt(row: row)
        router.openNotificationDetailView(notification)
    }

    private func openItemMenu1(row: Int) {
        let itemMenu = MyMenuRow1(raw: row)
        switch itemMenu {
        case .point:
            router.openPointBalance()
        case .changeUserInfo:
            router.openChangeUserInfoOption()
        case .notificationSettings:
            router.openSettingView()
        case .scanQRCode:
            router.openQRScanner()
        /*
        case .dataTransfer:
            router.openDataTransfer()
        case .faq:
            router.openTerms(
                url: URL(string: "about:blank"),
                title: itemMenu.title
            )
        */
        }
    }

    private func openItemMenu2(row: Int) {
        let itemMenu = MyMenuRow2(raw: row)
        switch itemMenu {
        case .faq:
            router.openTerms(
                url: URL(string: "http://app.merry.inc/app/faq/"),
                title: itemMenu.title
            )
        case .privacy:
            router.openTerms(
                url: URL(string: "http://app.merry.inc/app/privacy/"),
                title: itemMenu.title
            )
        /*
        case .sctl:
            router.openTerms(
                url: URL(string: "about:blank"),
                title: itemMenu.title
            )
        */
        case .terms:
            router.openTerms(
                url: URL(string: "http://app.merry.inc/app/terms/"),
                title: itemMenu.title
            )
        case .unregister:
            router.openUnregisterView()
        case .logout:
            presentConfirmAlertWith(message: R.string.localization.logoutMessage.localized(),
                                    cancelTitle: R.string.localization.logoutCancel.localized(),
                                    confirmButtonTitle: R.string.localization.logoutConfirm.localized(),
                                    callback: { (alert) in
                                        if alert.style == .default {
                                            backToFirstView()
                                        }
            })
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension MyMenuViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsAt(section: section)
    }

    private func getCellIdentifier(for section: Int) -> String {
        let sectionType = MyMenuSection(raw: section)
        switch sectionType {
        case .notification:
            return MyMenu2TableViewCell.identifier
        case .menu1:
            return MyMenu1TableViewCell.identifier
        case .menu2:
            return MyMenu2TableViewCell.identifier
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = getCellIdentifier(for: indexPath.section)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ShadowTableViewCell else {
                                                        fatalError()
        }

        cell.setIndexPath(indexPath: indexPath, sender: self)
        cell.configCellWithData(data: presenter.valueAt(indexPath: indexPath))
        // setCornerForCell(cell, at: indexPath)

        let sectionType = MyMenuSection(raw: indexPath.section)
        switch sectionType {
        case .menu2:
            let isVersionInfoRow = MyMenuRow2(raw: indexPath.row) == .versionInfo
            let accessoryType: UITableViewCell.AccessoryType = isVersionInfoRow ? .none : .disclosureIndicator
            (cell as? MyMenu2TableViewCell)?.set(accessoryType: accessoryType)
        default:
            break
        }

        return cell
    }

    private func setCornerForCell(_ cell: ShadowTableViewCell, at indexPath: IndexPath) {
        let sectionType = MyMenuSection(raw: indexPath.section)
        switch sectionType {
        case .menu2:
            let numberOfRows = presenter.numberOfRowsAt(section: indexPath.section)
            let cornerType: CornerType
            if numberOfRows == 1 {
                cornerType = .all
            } else if indexPath.row == 0 {
                cornerType = .top
            } else if indexPath.row == numberOfRows - 1 {
                cornerType = .bottom
            } else {
                cornerType = .none
            }

            cell.setCornerType(cornerType,
                               cornerPadding: CornerPadding(x: 12.0, y: 8.0),
                               in: tableView)
        default:
            cell.setCornerType(.all,
                               cornerPadding: CornerPadding(x: 12.0, y: 8.0),
                               in: tableView)
        }
    }
}

// MARK: - UITableViewDelegate

extension MyMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = MyMenuSection(raw: section)
        switch sectionType {
        case .notification:
            let height = presenter.hasNotificaton
                ? UITableView.automaticDimension
                : NumberConstant.minHeaderHeightForGroupedTable
            return height
        case .menu1:
            return UITableView.automaticDimension
        case .menu2:
            return 5.0
        }
    }

    private func getHeaderIdentifier(for section: Int) -> String {
        let sectionType = MyMenuSection(raw: section)
        switch sectionType {
        case .notification:
            return TitleOnlyTableViewHeaderView.identifier
        case .menu1:
            return TitleOnlyTableViewHeaderView.identifier
        case .menu2:
            return TSConstants.EMPTY_STRING
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerIdentifier = getHeaderIdentifier(for: section)
        guard !headerIdentifier.isEmpty else {
            return nil
        }

        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: headerIdentifier
            ) as? TSBaseTableViewHeaderFooterView

        headerView?.setSection(section: section, sender: self)
        headerView?.configHeaderWithData(data: presenter.sectionTitleAt(section: section))

        let sectionType = MyMenuSection(raw: section)
        switch sectionType {
        case .notification:
            (headerView as? TitleOnlyTableViewHeaderView)?.isVisibleMoreButton = true
        default:
            break
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sectionType = MyMenuSection(raw: indexPath.section)
        switch sectionType {
        case .notification:
            openNotification(row: indexPath.row)
        case .menu2:
            openItemMenu2(row: indexPath.row)
        default:
            break
        }
    }
}

// MARK: - MyMenu1TableViewCellDelegate

extension MyMenuViewController: MyMenu1TableViewCellDelegate {

    func openItem(_ item: MyMenuRow1) {
        openItemMenu1(row: item.rawValue)
    }
}

// MARK: - TitleOnlyTableViewHeaderViewDelegate

extension MyMenuViewController: TitleOnlyTableViewHeaderViewDelegate {

    func showMoreAt(_ section: Int) {
        let sectionType = MyMenuSection(raw: section)
        switch sectionType {
        case .notification:
            router.openNotificationListView()
        default:
            break
        }
    }
}

// MARK: - MyMenuViewDelegate

extension MyMenuViewController: MyMenuViewDelegate {

    func didLoadNotifications() {
        tableView.reloadData()
    }
}
