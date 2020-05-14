//
//  PointViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class PointViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var tableView: UITableView!

    // MARK: - Variable

    fileprivate let presenter = PointPresenter()
    fileprivate var router = PointRouter()

    // MARK: - Initialize

    class func newInstance() -> PointViewController {
        guard let newInstance = R.storyboard.point.pointViewController() else {
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

    func set(router: PointRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.loadPointHistory()
    }
}

extension PointViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configTableView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.point.localized()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
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
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 80
            $0.rowHeight = UITableView.automaticDimension
            $0.sectionFooterHeight = NumberConstant.minHeaderHeightForGroupedTable
        }
        extendBottomInsetIfNeed(for: tableView)

        _ = tableView.then {
            $0.register(TitleOnlyTableViewHeaderView.self,
                        forHeaderFooterViewReuseIdentifier: TitleOnlyTableViewHeaderView.identifier)
            $0.register(UINib(resource: R.nib.pointBalanceTableViewCell),
                        forCellReuseIdentifier: PointBalanceTableViewCell.identifier)
            $0.register(UINib(resource: R.nib.pointHistoryTableViewCell),
                        forCellReuseIdentifier: PointHistoryTableViewCell.identifier)
        }
    }
}

// MARK: - Actions

extension PointViewController {

    override func actionBack() {
        router.close()
    }
}

// MARK: - UITableViewDataSource

extension PointViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsAt(section: section)
    }

    private func getCellIdentifier(for section: Int) -> String {
        let sectionType = PointSection(raw: section)
        switch sectionType {
        case .balance:
            return PointBalanceTableViewCell.identifier
        case .history:
            return PointHistoryTableViewCell.identifier
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

        return cell
    }

    private func setCornerForCell(_ cell: ShadowTableViewCell, at indexPath: IndexPath) {
        let sectionType = PointSection(raw: indexPath.section)
        switch sectionType {
        case .history:
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
                               cornerPadding: CornerPadding(x: 8.0, y: 8.0),
                               in: tableView)
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate

extension PointViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleOnlyTableViewHeaderView.identifier
        ) as? TSBaseTableViewHeaderFooterView

        headerView?.configHeaderWithData(data: presenter.sectionTitleAt(section: section))

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sectionType = PointSection(raw: indexPath.section)
        switch sectionType {
        case .history:
            break
        default:
            break
        }
    }
}

// MARK: - PointBalanceTableViewCellDelegate

extension PointViewController: PointBalanceTableViewCellDelegate {

    func openQRScanner() {
        router.openQRScanner()
    }
}

// MARK: - PointViewDelegate

extension PointViewController: PointViewDelegate {

    func didLoadPointHistory() {
        tableView.reloadData()
    }
}
