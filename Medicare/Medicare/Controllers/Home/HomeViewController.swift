//
//  HomeViewController.swift
//  Medicare
//
//  Created by Thuan on 3/5/20.
//

import UIKit
import Cartography
import PullToRefresh

enum HomeSectionType: Int {
    case magazine = 0
    case video
    case gift
}

final class HomeViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tblView: UITableView!

    // MARK: Variables

    fileprivate var magazineItems = [MagazineModel]()
    fileprivate var videoItems = [VideoModel]()
    fileprivate var giftItems = [GiftModel]()

    fileprivate let route = HomeViewRouter()
    fileprivate var p: HomePresenter?
    fileprivate var cellHeights = [IndexPath: CGFloat]()

    // MARK: - Initialize

    class func newInstance() -> HomeViewController {
        guard let newInstance = R.storyboard.home.homeViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addLogoView()
        ShareManager.shared.currentHomePage = true
        loadHomeData()
    }
}

extension HomeViewController {

    override func configView() {
        super.configView()

        route.viewController = self

        configTableView()

        p = HomePresenter()
        p?.delegate = self
    }

    fileprivate func configTableView() {
        _ = tblView.then {
            $0.register(UINib(nibName: R.nib.homeMagazineTableViewCell.name, bundle: nil),
                            forCellReuseIdentifier: R.reuseIdentifier.homeMagazineTableViewCellID.identifier)
            $0.register(UINib(nibName: R.nib.homeGiftTableViewCell.name, bundle: nil),
                            forCellReuseIdentifier: R.reuseIdentifier.homeGiftTableViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = UIColor.clear
            $0.backgroundColor = UIColor.clear
        }
        extendBottomInsetIfNeed(for: tblView)

        tblView.addPullToRefresh(PullToRefresh()) {
            self.loadHomeData(showHUD: false)
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle("")

        setNavigationBarButton(items: [
            (.myPage, .right)
        ])
    }
}

extension HomeViewController {

    fileprivate func loadHomeData(showHUD: Bool = true) {
        p?.loadData(showHUD: showHUD)
    }

    fileprivate func magazineLike(_ item: MagazineModel) {
        p?.magazineLike(item.id)
    }

    fileprivate func magazineFavorite(_ item: MagazineModel) {
        p?.magazineFavorite(item.id, isFavorite: item.favorite_flg) { [weak self] in
            item.favorite_flg = (item.favorite_flg == 1) ? 0 : 1
            self?.tblView.reloadData()
        }
    }

    fileprivate func videoLike(_ item: VideoModel) {
        p?.videoLike(item.id)
    }

    fileprivate func videoFavorite(_ item: VideoModel) {
        p?.videoFavorite(item.id, isFavorite: item.favorite_flg) { [weak self] in
            item.favorite_flg = (item.favorite_flg == 1) ? 0 : 1
            self?.tblView.reloadData()
        }
    }
}

extension HomeViewController {

    fileprivate func createMagazineSection(_ tableView: UITableView,
                                           cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.homeMagazineTableViewCellID.identifier,
                        for: indexPath) as? TSBaseTableViewCell else {
                            return UITableViewCell()
        }

        cell.configCellWithData(data: magazineItems[indexPath.row])
        if let cell = cell as? HomeMagazineTableViewCell {

            cell.favorite = { [unowned self] cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.magazineItems[index.row]
                    self.magazineFavorite(item)
                }
            }

            cell.like = { cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.magazineItems[index.row]
                    self.magazineLike(item)
                }
            }
        }

        return cell
    }

    fileprivate func createVideoSection(_ tableView: UITableView,
                                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.homeMagazineTableViewCellID.identifier,
                        for: indexPath) as? TSBaseTableViewCell else {
                            return UITableViewCell()
        }

        cell.configCellWithData(data: videoItems[indexPath.row])
        if let cell = cell as? HomeMagazineTableViewCell {

            cell.favorite = { [unowned self] cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.videoItems[index.row]
                    self.videoFavorite(item)
                }
            }

            cell.like = { cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.videoItems[index.row]
                    self.videoLike(item)
                }
            }
        }

        return cell
    }

    fileprivate func createGiftSection(_ tableView: UITableView,
                                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.homeGiftTableViewCellID.identifier,
                        for: indexPath) as? TSBaseTableViewCell else {
                            return UITableViewCell()
        }

        cell.configCellWithData(data: giftItems[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case HomeSectionType.magazine.rawValue:
            return magazineItems.count
        case HomeSectionType.video.rawValue:
            return videoItems.count
        case HomeSectionType.gift.rawValue:
            return giftItems.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case HomeSectionType.magazine.rawValue:
            return createMagazineSection(tableView, cellForRowAt: indexPath)
        case HomeSectionType.video.rawValue:
            return createVideoSection(tableView, cellForRowAt: indexPath)
        case HomeSectionType.gift.rawValue:
            return createGiftSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case HomeSectionType.magazine.rawValue:
            route.openMagazineDetailView(magazineItems[indexPath.row])
        case HomeSectionType.video.rawValue:
            route.openVideoDetailView(videoItems[indexPath.row])
        case HomeSectionType.gift.rawValue:
            route.openGiftDetailView(giftItems[indexPath.row])
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.homeTableViewHeaderView.firstView(owner: nil)
        header?.setData(section)

        switch section {
        case HomeSectionType.magazine.rawValue:
            header?.isHidden = magazineItems.isEmpty
        case HomeSectionType.video.rawValue:
            header?.isHidden = videoItems.isEmpty
        case HomeSectionType.gift.rawValue:
            header?.isHidden = giftItems.isEmpty
        default:
            break
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case HomeSectionType.magazine.rawValue:
            return magazineItems.isEmpty ? 0.1 : 35.0
        case HomeSectionType.video.rawValue:
            return videoItems.isEmpty ? 0.1 : 35.0
        case HomeSectionType.gift.rawValue:
            return giftItems.isEmpty ? 0.1 : 35.0
        default:
            return 0.1
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case HomeSectionType.magazine.rawValue:
            return magazineItems.isEmpty ? 0.1 : 10.0
        case HomeSectionType.video.rawValue:
            return videoItems.isEmpty ? 0.1 : 10.0
        default:
            return 0.1
        }
    }
}

extension HomeViewController: HomePresenterDelegate {

    func loadDataCompleted(_ magazineItems: [MagazineModel],
                           videoItems: [VideoModel],
                           giftItems: [GiftModel]) {
        self.magazineItems = magazineItems
        self.videoItems = videoItems
        self.giftItems = giftItems
        tblView.endAllRefreshing()
        tblView.reloadData()
    }

    func magazineLikeCompleted(_ like: LikeModel?) {
        guard let like = like else {
            return
        }

        let item = magazineItems.first(where: { $0.id == like.id })
        item?.good_flg = (item?.good_flg == 1) ? 0 : 1
        item?.good = like.good ?? 0
        tblView.reloadData()
    }

    func videoLikeCompleted(_ like: LikeModel?) {
        guard let like = like else {
            return
        }

        let item = videoItems.first(where: { $0.id == like.id })
        item?.good_flg = (item?.good_flg == 1) ? 0 : 1
        item?.good = like.good ?? 0
        tblView.reloadData()
    }
}
