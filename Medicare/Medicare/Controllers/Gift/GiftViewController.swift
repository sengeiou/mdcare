//
//  GiftViewController.swift
//  Medicare
//
//  Created by Thuan on 3/4/20.
//

import UIKit
import PullToRefresh

final class GiftViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tblView: UITableView!

    // MARK: Variables

    fileprivate var newestItems = [GiftModel]()
    fileprivate let route = GiftViewRouter()
    fileprivate var p: GiftPresenter?
    fileprivate var pageSize = NumberConstant.pageSize
    fileprivate var pageIndex = NumberConstant.startPageIndex
    fileprivate var tempPageIndex = NumberConstant.startPageIndex
    fileprivate var canLoadMore = false

    // MARK: - Initialize

    class func newInstance() -> GiftViewController {
        guard let newInstance = R.storyboard.gift.giftViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resetPageIdex(newestItems.count)
    }
}

extension GiftViewController {

    override func configView() {
        super.configView()

        route.viewController = self

        configTableView()

        p = GiftPresenter()
        p?.delegate = self
    }

    fileprivate func configTableView() {
        _ = tblView.then {
            $0.register(UINib(nibName: R.nib.homeGiftTableViewCell.name, bundle: nil),
                            forCellReuseIdentifier: R.reuseIdentifier.homeGiftTableViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = UIColor.clear
            $0.backgroundColor = UIColor.clear
        }
        extendBottomInsetIfNeed(for: tblView)

        tblView.addPullToRefresh(PullToRefresh()) {
            self.resetPageIdex()
            self.loadData(showHUD: false)
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle(R.string.localization.giftString001.localized())

        setNavigationBarButton(items: [
            (.home, .left),
            (.myPage, .right)
        ])
    }
}

extension GiftViewController {

    fileprivate func createMainSection(_ tableView: UITableView,
                                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.homeGiftTableViewCellID.identifier,
                        for: indexPath) as? TSBaseTableViewCell else {
                            fatalError()
        }

        cell.configCellWithData(data: newestItems[indexPath.row])
        return cell
    }

    fileprivate func loadData(showHUD: Bool = true) {
        p?.loadData(pageSize: pageSize, pageIndex: pageIndex, showHUD: showHUD)
    }

    fileprivate func resetPageIfNeeded() {
        let pageSizeConst = NumberConstant.pageSize
        if pageSize <= pageSizeConst {
            return
        }

        if pageSize%pageSizeConst == 0 {
            pageIndex = pageSize/pageSizeConst - 1
            pageSize = pageSizeConst
        } else {
            pageIndex = pageSize%pageSizeConst
            pageSize = pageSizeConst
        }
    }

    fileprivate func resetPageIdex(_ newPageSize: Int? = nil) {
        pageSize = newPageSize ?? NumberConstant.pageSize
        pageIndex = NumberConstant.startPageIndex
        tempPageIndex = pageIndex
    }
}

extension GiftViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newestItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMainSection(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if canLoadMore {
            tableView.addLoading(indexPath) { [weak self] in
                self?.canLoadMore = false
                self?.tempPageIndex = self?.pageIndex ?? 0
                self?.pageIndex += 1
                self?.loadData(showHUD: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        route.openGiftDetailView(newestItems[indexPath.row])
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension GiftViewController: GiftPresenterDelegate {

    func loadDataCompleted(_ newestItems: [GiftModel], error: String?) {
        tblView.endAllRefreshing()
        tblView.stopLoading()
        if error != nil {
            canLoadMore = true
            pageIndex = tempPageIndex
            return

        }
        canLoadMore = !(newestItems.count < pageSize)
        if pageIndex == NumberConstant.startPageIndex {
            self.newestItems = newestItems
        } else {
            self.newestItems += newestItems
        }
        tblView.reloadData()
        resetPageIfNeeded()
    }
}
