//
//  VideoViewController.swift
//  Medicare
//
//  Created by Thuan on 3/4/20.
//

import UIKit
import Cartography

final class VideoViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var contentContainerView: UIView!

    // MARK: Variables

    fileprivate var contentView: ContainerVideoViewController?
    var route: VideoRouter?
    fileprivate var p: VideoViewPresenter?
    fileprivate var isShowingChannelList = true

    // MARK: - Initialize

    class func newInstance() -> VideoViewController {
        guard let newInstance = R.storyboard.video.videoViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func logEvent() {}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func actionBack() {
//        route?.close()
        NotificationCenter.default.post(name: NSNotification.Name(StringConstant.videoBackNotification),
                                        object: route,
                                        userInfo: nil)
    }
}

extension VideoViewController {

    override func configView() {
        super.configView()

//        configContentView()
        p = VideoViewPresenter()
        p?.delegate = self
        p?.showVideoTab()
    }

    fileprivate func configContentView(_ categoryList: [VideoCategoryModel]) {
        contentView = ContainerVideoViewController()
        contentView!.categoryList = categoryList
        contentView!.customDelegate = self
        self.addChild(contentView!)
        contentContainerView.addSubview(contentView!.view)
        contentView!.didMove(toParent: self)

        constrain(contentView!.view) { (view) in
            view.width == view.superview!.width
            view.height == view.superview!.height
            view.left == view.superview!.left
            view.top == view.superview!.top
        }

        contentView!.reloadTitle = { [unowned self] index in
            self.reloadTitle(index)
            if index == VideoTabIndex.channelList.rawValue && !self.isShowingChannelList {
                self.addNavBarButton(showBack: true)
            } else {
                self.addNavBarButton(showBack: false)
            }
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

//        setTitle(R.string.localization.videoString001.localized())
        reloadTitle(VideoTabIndex.videoList.rawValue)
        addNavBarButton(showBack: false)
    }
}
extension VideoViewController: VideoViewPresenterDelegate {

    func showVideoTabCompleted(_ categoryList: [VideoCategoryModel]) {
        configContentView(categoryList)
    }
}

extension VideoViewController {

    fileprivate func reloadTitle(_ index: Int) {
        switch index {
        case VideoTabIndex.channelList.rawValue:
            if isShowingChannelList {
                setTitle(R.string.localization.videoChannelListTitle.localized())
            } else {
                setTitle(R.string.localization.videoString001.localized())
            }
        case VideoTabIndex.ranking.rawValue:
            setTitle(R.string.localization.videoString003.localized())
        case VideoTabIndex.favourite.rawValue:
            setTitle(R.string.localization.videoString005.localized())
        default:
            setTitle(R.string.localization.videoString001.localized())
        }
    }

    fileprivate func addNavBarButton(showBack: Bool) {
        if showBack {
            setNavigationBarButton(items: [
                (.back(title: R.string.localization.return.localized()), .left)
            ])
        } else {
            setNavigationBarButton(items: [
                (.home, .left),
                (.myPage, .right)
            ])
        }
    }
}

extension VideoViewController: ContainerVideoViewControllerDelegate {

    func didSelectChannelList() {
        addNavBarButton(showBack: true)
        isShowingChannelList = false
        reloadTitle(VideoTabIndex.channelList.rawValue)
    }

    func didBackToChannelList() {
        addNavBarButton(showBack: false)
        isShowingChannelList = true
        reloadTitle(VideoTabIndex.channelList.rawValue)
    }
}
