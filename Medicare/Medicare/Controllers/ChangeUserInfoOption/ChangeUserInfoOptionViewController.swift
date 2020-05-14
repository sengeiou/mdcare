//
//  ChangeUserInfoOptionViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class ChangeUserInfoOptionViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var tableView: UITableView!

    // MARK: - Variable

    fileprivate let presenter = ChangeUserInfoOptionPresenter()
    fileprivate var router = ChangeUserInfoOptionRouter()

    // MARK: - Initialize

    class func newInstance() -> ChangeUserInfoOptionViewController {
        guard let newInstance = R.storyboard.myMenu.changeUserInfoOptionViewController() else {
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

    func set(router: ChangeUserInfoOptionRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.getUserInfo()
    }
}

extension ChangeUserInfoOptionViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configTableView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.changeUserInformation.localized()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

    private func configTableView() {
        _ = tableView.then {
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = view.backgroundColor
            $0.separatorStyle = .none
            $0.estimatedRowHeight = 80
            $0.rowHeight = UITableView.automaticDimension
            $0.sectionFooterHeight = NumberConstant.minHeaderHeightForGroupedTable
        }
        extendBottomInsetIfNeed(for: tableView)

        _ = tableView.then {
            $0.register(UINib(resource: R.nib.userInfoOptionTableViewCell),
                        forCellReuseIdentifier: UserInfoOptionTableViewCell.identifier)
        }
    }
}

// MARK: - Actions

extension ChangeUserInfoOptionViewController {

    private func openOption(row: Int) {
        let option = ChangeUserInfoOptionRow(raw: row)
        switch option {
        case .categoryAndTag:
            router.openCategorySetting(isRegistration: false, isHiddenBack: false)
        case .personalInfo:
            router.openChangePersonalInfo()
        case .magazineSubscriptionInfo:
            break
        }
    }

    override func actionBack() {
        router.close()
    }
}

// MARK: - UITableViewDataSource

extension ChangeUserInfoOptionViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsAt(section: section)
    }

    private func getCellIdentifier(for section: Int) -> String {
        let sectionType = ChangeUserInfoOptionSection(raw: section)
        switch sectionType {
        case .option:
            return UserInfoOptionTableViewCell.identifier
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
        setCornerForCell(cell, at: indexPath)

//        let sectionType = ChangeUserInfoOptionSection(raw: indexPath.section)
//        switch sectionType {
//        case .option:
//            (cell as? UserInfoOptionTableViewCell)?.set(accessoryType: .disclosureIndicator)
//        }

        if indexPath.row == ChangeUserInfoOptionRow.magazineSubscriptionInfo.rawValue {
            (cell as? UserInfoOptionTableViewCell)?.set(accessoryType: .none)
            (cell as? UserInfoOptionTableViewCell)?.setInfo(presenter.tempUserDetail)
        } else {
            (cell as? UserInfoOptionTableViewCell)?.set(accessoryType: .disclosureIndicator)
            (cell as? UserInfoOptionTableViewCell)?.setInfo(nil)
        }

        return cell
    }

    private func setCornerForCell(_ cell: ShadowTableViewCell, at indexPath: IndexPath) {
        let sectionType = ChangeUserInfoOptionSection(raw: indexPath.section)
        switch sectionType {
        case .option:
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
        }
    }
}

// MARK: - UITableViewDelegate

extension ChangeUserInfoOptionViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NumberConstant.minHeaderHeightForGroupedTable
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sectionType = ChangeUserInfoOptionSection(raw: indexPath.section)
        switch sectionType {
        case .option:
            openOption(row: indexPath.row)
        }
    }
}

// MARK: - ChangeUserInfoOptionViewDelegate

extension ChangeUserInfoOptionViewController: ChangeUserInfoOptionViewDelegate {

    func didGetUserInfo() {
        tableView.reloadData()
    }
}
