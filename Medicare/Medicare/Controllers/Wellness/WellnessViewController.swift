//
//  WellnessViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit
import PullToRefresh

final class WellnessViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var tableView: UITableView!

    // MARK: - Variable

    fileprivate let presenter = WellnessPresenter()
    fileprivate var router = WellnessRouter()
    fileprivate let refresh = PullToRefresh()

    deinit {
        tableView?.removeAllPullToRefresh()
        unregisterCategorySettingChangesNotification()
    }

    // MARK: - Initialize

    class func newInstance() -> WellnessViewController {
        guard let newInstance = R.storyboard.wellness.wellnessViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        registerCategorySettingChangesNotification()
    }

    func set(router: WellnessRouter) {
        self.router = router
    }

    private func registerCategorySettingChangesNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadData),
            name: NSNotification.Name(StringConstant.categorySettingChangesNotification),
            object: nil
        )
    }

    private func unregisterCategorySettingChangesNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(StringConstant.categorySettingChangesNotification),
            object: nil
        )
    }

    @objc private func loadData() {
        presenter.loadCategory()
        tableView.endAllRefreshing()
    }
}

extension WellnessViewController {

    override func configView() {
        super.configView()

        view.backgroundColor = ColorName.cF2F2F2.color

        presenter.set(delegate: self)
        router.viewController = self
        configTableView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.wellness.localized()

        setNavigationBarButton(items: [
            (.home, .left),
            (.myPage, .right)
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
            $0.sectionFooterHeight = 15.0
        }
        extendBottomInsetIfNeed(for: tableView)

        _ = tableView.then {
            $0.register(TitleOnlyTableViewHeaderView.self,
                        forHeaderFooterViewReuseIdentifier: TitleOnlyTableViewHeaderView.identifier)
            $0.register(WellnessTableViewCell.self,
                        forCellReuseIdentifier: WellnessTableViewCell.identifier)
        }

        tableView.addPullToRefresh(refresh) { [weak self] in
            guard let weakSelf = self else {
                return
            }

            weakSelf.loadData()
        }
    }
}

// MARK: - Actions

extension WellnessViewController {

}

// MARK: - UITableViewDataSource

extension WellnessViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    private func getCellIdentifier(for section: Int) -> String {
        return WellnessTableViewCell.identifier
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = getCellIdentifier(for: indexPath.section)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ShadowTableViewCell else {
                                                        fatalError()
        }

        cell.setIndexPath(indexPath: indexPath, sender: self)
        cell.configCellWithData(data: presenter)
        /*
        cell.setCornerType(.all,
                           cornerPadding: CornerPadding(x: 12.0, y: 8.0),
                           in: tableView)
        */

        return cell
    }
}

// MARK: - UITableViewDelegate

extension WellnessViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleOnlyTableViewHeaderView.identifier
        ) as? TitleOnlyTableViewHeaderView

        let categoryType = presenter.categoryTypeAt(section: section)

        headerView?.configHeaderWithData(data: presenter.sectionTitleAt(section: section))
        headerView?.setImage(categoryType.image)

        return headerView
    }
}

// MARK: - WellnessTableViewCellDelegate

extension WellnessViewController: WellnessTableViewCellDelegate {

    func openItemAt(indexPath: IndexPath) {
        let categoryType = presenter.categoryTypeAt(section: indexPath.section)
        let media = presenter.mediaAt(indexPath: indexPath)
        switch categoryType {
        case .magazine:
            router.openMagazineDetailView(media as? MagazineModel)
        case .video:
            router.openVideoDetailView(media as? VideoModel)
        case .present:
            router.openGiftDetailView(media as? GiftModel)
        default:
            break
        }
    }
}

// MARK: - WellnessViewDelegate

extension WellnessViewController: WellnessViewDelegate {

    func didLoadCategory() {
        tableView.reloadData()
    }
}
