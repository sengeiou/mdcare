//
//  ContentVideoViewController.swift
//  Medicare
//
//  Created by Thuan on 3/7/20.
//

import UIKit
import XLPagerTabStrip
import PullToRefresh
import Firebase

protocol ContentVideoViewControllerDelegate: class {
    func didSelectChannelList()
    func didBackToChannelList()
}

private let videoChannelId = R.reuseIdentifier.videoChannelCollectionViewCellID.identifier

final class ContentVideoViewController: BaseViewController, IndicatorInfoProvider {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tblView: UITableView!
    @IBOutlet weak var colView: UICollectionView!

    // MARK: Variables

    fileprivate var videoItems = [VideoModel]()
    fileprivate var channelItems = [VideoChannelModel]()

    var parentVC: UIViewController?
    var itemInfo = IndicatorInfo(title: "View")
    var videoTabIndex: VideoTabIndex = .none
    fileprivate let route = ContentVideoRouter()
    fileprivate var hiddenHeader: Bool {
        return !(videoTabIndex == .channelList)
    }
    fileprivate var showingChannelList: Bool {
        return tblView.isHidden && !colView.isHidden
    }
    fileprivate var p: VideoViewPresenter?
    fileprivate var channelSelected: VideoChannelModel?
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    fileprivate var pageSize = NumberConstant.pageSize
    fileprivate var pageIndex = NumberConstant.startPageIndex
    fileprivate var tempPageIndex = NumberConstant.startPageIndex
    fileprivate var canLoadMore = false
    weak var delegate: ContentVideoViewControllerDelegate?

    // MARK: - Initialize

    class func newInstance() -> ContentVideoViewController {
        guard let newInstance = R.storyboard.video.contentVideoViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func logEvent() {
        var titleName = ""
        switch videoTabIndex {
        case .videoList:
            titleName = "動画ページTOP"
        case .channelList:
            titleName = "チャンネル一覧"
        case .ranking:
            titleName = "動画-ランキング"
        case .favourite:
            titleName = "動画- お気に入り"
        default:
            titleName = ""
        }

        if titleName.isEmpty {
            return
        }

        Analytics.setScreenName(titleName, screenClass: self.description)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(backAction(_:)),
                                               name: NSNotification.Name(StringConstant.videoBackNotification),
                                               object: nil)

        if videoTabIndex == .channelList {
            loadChannels()
        } else {
            loadVideos()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(StringConstant.videoBackNotification),
                                                  object: nil)

        if videoTabIndex != .channelList {
            resetPageIdex(videoItems.count)
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    @objc fileprivate func backAction(_ notification: Notification) {
        channelListVisible(true)
        delegate?.didBackToChannelList()
    }
}

extension ContentVideoViewController {

    override func configView() {
        super.configView()

        route.viewController = self

        configTableView()
        configCollectionView()

        p = VideoViewPresenter()
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
            $0.estimatedSectionHeaderHeight = 40
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.isHidden = (self.videoTabIndex == .channelList)
        }
        extendBottomInsetIfNeed(for: tblView)

        tblView.addPullToRefresh(PullToRefresh()) {
            self.resetPageIdex()
            self.loadVideos(showHUD: false)
        }
    }

    fileprivate func configCollectionView() {
        _ = colView.then {
            $0.register(UINib(nibName: R.nib.videoChannelCollectionViewCell.name, bundle: nil),
                        forCellWithReuseIdentifier: videoChannelId)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = UIColor.clear
            $0.isHidden = !(self.videoTabIndex == .channelList)
            $0.alwaysBounceVertical = true

            var widthItem = view.frame.width
            var heightItem: CGFloat = 54.0
            if isIpad {
                widthItem /= 2
                heightItem = 70.0
            }
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: widthItem, height: heightItem)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            $0.collectionViewLayout = layout
        }
        extendBottomInsetIfNeed(for: colView)

        colView.addPullToRefresh(PullToRefresh()) {
            self.loadChannels(showHUD: false)
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

extension ContentVideoViewController {

    func dismissChannelDetailIfNeeded() {
        if tblView != nil && videoTabIndex == .channelList {
            if !showingChannelList {
                channelListVisible(true)
                delegate?.didBackToChannelList()
            }
            loadChannels()
        }
    }

    fileprivate func loadVideos(showHUD: Bool = true) {
        p?.loadVideos(videoTabIndex,
                      channelId: channelSelected?.id,
                      pageSize: pageSize,
                      pageIndex: pageIndex,
                      showHUD: showHUD)
    }

    fileprivate func loadChannels(showHUD: Bool = true) {
        p?.loadChannels(showHUD: showHUD)
    }

    fileprivate func channelListVisible(_ visible: Bool) {
        if visible {
            channelSelected = nil
        }
        tblView.isHidden = visible
        colView.isHidden = !visible
    }

    fileprivate func like(_ item: VideoModel) {
        p?.videoLike(item.id)
    }

    fileprivate func favorite(_ item: VideoModel) {
        p?.videoFavorite(item.id, isFavorite: item.favorite_flg) { [unowned self] in
            item.favorite_flg = (item.favorite_flg == 1) ? 0 : 1
            if let index = self.videoItems.firstIndex(where: { $0.id == item.id }),
                self.videoTabIndex == .favourite {
                self.videoItems.remove(at: index)
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

extension ContentVideoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = R.reuseIdentifier.videoTableViewCellID.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? TSBaseTableViewCell else {
                                                        fatalError()
        }

        cell.setIndexPath(indexPath: indexPath, sender: self)
        cell.configCellWithData(data: videoItems[indexPath.row])
        if let cell = cell as? VideoTableViewCell {
            let rankingVisible = videoTabIndex == .ranking
            cell.setRankingVisible(rankingVisible)

            cell.favorite = { [unowned self] cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.videoItems[index.row]
                    self.favorite(item)
                }
            }

            cell.like = { cell in
                if let cell = cell, let index = tableView.indexPath(for: cell) {
                    let item = self.videoItems[index.row]
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
                self?.loadVideos(showHUD: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        route.openVideoDetailView(videoItems[indexPath.row])
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if hiddenHeader {
            return UIView()
        }
        let header = R.nib.videoHeaderView.firstView(owner: nil)
        header?.setData(channelSelected)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hiddenHeader {
            return 0.1
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension ContentVideoViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoChannelId,
                                                            for: indexPath) as? TSBaseCollectionViewCell else {
                                                                fatalError()
        }
        cell.configCellWithData(data: channelItems[indexPath.row])
        if let cell = cell as? VideoChannelCollectionViewCell {
            if isIpad {
                cell.hiddenAllSeparator()
            } else {
                cell.separatorBottomViewVisible(indexPath.row == channelItems.count - 1)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        channelSelected = channelItems[indexPath.row]
        loadVideos()
    }
}

extension ContentVideoViewController: VideoViewPresenterDelegate {

    func loadVideosCompleted(_ videoItems: [VideoModel], error: String?) {
        tblView.endAllRefreshing()
        tblView.stopLoading()
        if error != nil {
            canLoadMore = true
            pageIndex = tempPageIndex
            return
        }

        if channelSelected != nil {
            channelListVisible(false)
            delegate?.didSelectChannelList()
        }

        canLoadMore = !(videoItems.count < pageSize)
        if pageIndex == NumberConstant.startPageIndex {
            self.videoItems = videoItems
        } else {
            self.videoItems += videoItems
        }
        tblView.reloadData()
        resetPageIfNeeded()
    }

    func loadChannelsCompleted(_ channelItems: [VideoChannelModel]) {
        colView.endAllRefreshing()
        self.channelItems = channelItems
        colView.reloadData()
    }

    func likeCompleted(_ like: LikeModel?) {
        guard let like = like else {
            return
        }

        let item = videoItems.first(where: { $0.id == like.id })
        item?.good_flg = (item?.good_flg == 1) ? 0 : 1
        item?.good = like.good ?? 0
        tblView.reloadData()
    }
}
