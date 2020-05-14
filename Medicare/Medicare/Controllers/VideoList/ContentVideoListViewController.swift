//
//  ContentVideoListViewController.swift
//  Medicare
//
//  Created by Thuan on 3/17/20.
//

import Foundation
import XLPagerTabStrip

final class ContentVideoListViewController: BaseViewController, IndicatorInfoProvider {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tblView: UITableView!

    // MARK: Variables

    fileprivate var videoItems = [VideoModel]()
    fileprivate var p: ContentVideoListPresenter?
    fileprivate let route = ContentVideoListRouter()
    var itemInfo = IndicatorInfo(title: "View")

    // MARK: - Initialize

    class func newInstance() -> ContentVideoListViewController {
        guard let newInstance = R.storyboard.videoList.contentVideoListViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension ContentVideoListViewController {

    override func configView() {
        super.configView()

        route.viewController = self

        configTableView()

        p = ContentVideoListPresenter()
        p?.delegate = self
        p?.loadVideos()
    }

    fileprivate func configTableView() {
        _ = tblView.then {
            $0.register(UINib(nibName: R.nib.videoTableViewCell.name, bundle: nil),
                            forCellReuseIdentifier: R.reuseIdentifier.videoTableViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = UIColor.clear
            $0.backgroundColor = UIColor.white
        }
        extendBottomInsetIfNeed(for: tblView)
    }
}

extension ContentVideoListViewController: UITableViewDelegate, UITableViewDataSource {

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

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        route.openVideoDetailView(videoItems[indexPath.row])
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
        if hasTopNotch {
            return NumberConstant.commonBottomPadding
        }
        return 0.1
    }
}

extension ContentVideoListViewController: ContentVideoListPresenterDelegate {

    func loadVideosCompleted(_ videoItems: [VideoModel]) {
        self.videoItems = videoItems
        tblView.reloadData()
    }
}
