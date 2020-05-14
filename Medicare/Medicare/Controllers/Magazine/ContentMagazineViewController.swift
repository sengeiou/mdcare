//
//  ContentMagazineViewController.swift
//  Medicare
//
//  Created by Thuan on 3/13/20.
//

import UIKit
import XLPagerTabStrip
import PullToRefresh
import Firebase

final class ContentMagazineViewController: BaseViewController, IndicatorInfoProvider {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tblView: UITableView!

    // MARK: Variables

    fileprivate var magazineItems = [MagazineModel]()

    var parentVC: UIViewController?
    var itemInfo = IndicatorInfo(title: "View")
    fileprivate let route = ContentMagazineRouter()
    fileprivate var p: MagazinePresenter?
    fileprivate var tabIndex: MagazineTabIndex {
        return category?.type ?? .other
    }
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    fileprivate var pageSize = NumberConstant.pageSize
    fileprivate var pageIndex = NumberConstant.startPageIndex
    fileprivate var tempPageIndex = NumberConstant.startPageIndex
    fileprivate var canLoadMore = false
    var category: MagazineCategoryModel?

    // MARK: - Initialize

    class func newInstance() -> ContentMagazineViewController {
        guard let newInstance = R.storyboard.magazine.contentMagazineViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func logEvent() {
        let titleName = "マガジン - \(category?.name ?? "")"
        Analytics.setScreenName(titleName, screenClass: self.description)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadMagazines()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resetPageIdex(magazineItems.count)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension ContentMagazineViewController {

    override func configView() {
        super.configView()

        route.viewController = self

        configTableView()

        p = MagazinePresenter()
        p?.delegate = self
    }

    fileprivate func configTableView() {
        _ = tblView.then {
            $0.register(UINib(nibName: R.nib.videoTableViewCell.name, bundle: nil),
                            forCellReuseIdentifier: R.reuseIdentifier.videoTableViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = UIColor.clear
            $0.backgroundColor = UIColor.clear
        }
        extendBottomInsetIfNeed(for: tblView)

        tblView.addPullToRefresh(PullToRefresh()) {
            self.resetPageIdex()
            self.loadMagazines(showHUD: false)
        }
    }

    override func extendBottomInsetIfNeed(for scrollView: UIScrollView) {
        var contentInset = scrollView.contentInset
        let tabBarHeight = parentVC?.tabBarController?.tabBar.bounds.height ?? 0.0
        contentInset.bottom = tabBarHeight
        scrollView.contentInset = contentInset

        let scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: -contentInset.bottom,
                                                 right: 0)
        if #available(iOS 11.1, *) {
            scrollView.verticalScrollIndicatorInsets = scrollIndicatorInsets
        } else {
            scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        }
    }
}

extension ContentMagazineViewController {

    fileprivate func loadMagazines(showHUD: Bool = true) {
        guard let category = category else {
            return
        }
        var type = ""
        switch category.type {

        case .all:
            type = MagazineCategoryType.top.rawValue
        case .ranking:
            type = MagazineCategoryType.ranking.rawValue
        case .favourite:
            type = MagazineCategoryType.favourite.rawValue
        default:
            type = MagazineCategoryType.category.rawValue
        }

        let params: [String: Any] = [
            "type": type,
            "category_id": category.id,
            "page_size": pageSize,
            "page_index": pageIndex
        ]
        p?.loadMagazines(params, showHUD: showHUD)
    }

    fileprivate func like(_ item: MagazineModel) {
        p?.magazineLike(item.id)
    }

    fileprivate func favorite(_ item: MagazineModel) {
        p?.magazineFavorite(item.id, isFavorite: item.favorite_flg) { [unowned self] in
            item.favorite_flg = (item.favorite_flg == 1) ? 0 : 1
            if let index = self.magazineItems.firstIndex(where: { $0.id == item.id }),
                self.tabIndex == .favourite {
                self.magazineItems.remove(at: index)
            }
            self.tblView.reloadData()
        }
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

extension ContentMagazineViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magazineItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = R.reuseIdentifier.videoTableViewCellID.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? TSBaseTableViewCell else {
                                                        fatalError()
        }

        cell.setIndexPath(indexPath: indexPath, sender: self)
        cell.configCellWithData(data: magazineItems[indexPath.row])
        if let cell = cell as? VideoTableViewCell {
            cell.setPlayingViewVisible(false)
            cell.setRankingVisible(tabIndex == .ranking)

            cell.favorite = { [unowned self] cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.magazineItems[index.row]
                    self.favorite(item)
                }
            }

            cell.like = { cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.magazineItems[index.row]
                    self.like(item)
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if canLoadMore {
            tableView.addLoading(indexPath) { [weak self] in
                self?.canLoadMore = false
                self?.tempPageIndex = self?.pageIndex ?? 0
                self?.pageIndex += 1
                self?.loadMagazines(showHUD: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        route.openMagazineDetailView(magazineItems[indexPath.row])
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

extension ContentMagazineViewController: MagazinePresenterDelegate {

    func loadMagazinesCompleted(_ magazineItems: [MagazineModel], error: String?) {
        tblView.endAllRefreshing()
        tblView.stopLoading()
        if error != nil {
            canLoadMore = true
            pageIndex = tempPageIndex
            return

        }
        canLoadMore = !(magazineItems.count < pageSize)
        if pageIndex == NumberConstant.startPageIndex {
            self.magazineItems = magazineItems
        } else {
            self.magazineItems += magazineItems
        }
        tblView.reloadData()
        resetPageIfNeeded()
    }

    func likeCompleted(_ like: LikeModel?) {
        guard let like = like else {
            return
        }

        let item = magazineItems.first(where: { $0.id == like.id })
        item?.good_flg = (item?.good_flg == 1) ? 0 : 1
        item?.good = like.good ?? 0
        tblView.reloadData()
    }
}
