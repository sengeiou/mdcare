//
//  DetailVideoViewController.swift
//  Medicare
//
//  Created by Thuan on 3/10/20.
//

import UIKit
import AVKit
import Kingfisher
import Cartography

extension UIViewController {

    func showVideoGrantPointPopup(_ point: String, size: CGSize) {
        let grantPointPopup = GrantPointPopup.newInstance().then {
            $0.point = point
            if size.width < size.height {
                $0.size = CGSize(width: self.view.frame.width - 40, height: 490)
            } else {
                var height = self.view.frame.height
                if height > 490 {
                    height = 490
                } else {
                    $0.needResize = true
                }
                $0.size = CGSize(width: height - 40, height: height)
            }
        }

        let formSheetController = MZFormSheetPresentationViewController(
            contentViewController: grantPointPopup
        ).then {
            $0.contentViewControllerTransitionStyle = .bounce
            $0.contentViewCornerRadius = 10.0
        }

        formSheetController.presentationController?.contentViewSize = UIView.layoutFittingCompressedSize

        present(formSheetController, animated: true, completion: nil)
    }
}

private struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

final class DetailVideoViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var thumbnail: UIImageView!
    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var lbContent: UILabel!
    @IBOutlet weak var imgChannel: UIImageView!
    @IBOutlet fileprivate weak var lbChannel: UILabel!
    @IBOutlet fileprivate weak var btnLike: UIButton!
    @IBOutlet fileprivate weak var btnFavourite: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedBackView: UIView!
    @IBOutlet weak var heightContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!

    // MARK: Variables

    fileprivate var isFirstLoad = true
    fileprivate var startDate: Date?
    fileprivate var navHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height +
            (self.navigationController?.navigationBar.frame.height ?? 0)
    }
    fileprivate var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0.0
    }
    var route: DetailVideoRouter?
    var video: VideoModel?
    fileprivate var p: DetailVideoPresenter?
    fileprivate var avPlayer: AVPlayerViewController?
    fileprivate var avTimer: Timer?

    // MARK: - Initialize

    class func newInstance() -> DetailVideoViewController {
        guard let newInstance = R.storyboard.video.detailVideoViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    deinit {
        avTimer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if isFirstLoad {
            calculateContainerSize()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        feedBackViewVisible(true)
        avTimer?.invalidate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        isFirstLoad = false
        fitContainerSize()
    }

    override func actionBack() {
        route?.close()
    }
}

extension DetailVideoViewController {

    override func configView() {
        super.configView()

        view.backgroundColor = UIColor.white

        configLabels()
        configButtons()
        configScrollView()
        configThumbnail()
        addActionForButtons()
        addActionForThumbnail()
        setData()

        p = DetailVideoPresenter()
        p?.delegate = self
        pageView()
    }

    fileprivate func configScrollView() {
        _ = scrollView.then {
            $0.delegate = self
        }
        extendBottomInsetIfNeed(for: scrollView)
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbContent.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbChannel.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configButtons() {
        _ = btnLike.then {
            $0.setImage(R.image.ungood_icon(), for: .normal)
            $0.setImage(R.image.good_icon(), for: .selected)
        }

        _ = btnFavourite.then {
            $0.setImage(R.image.unfavourite_icon(), for: .normal)
            $0.setImage(R.image.favourite_icon(), for: .selected)
        }
    }

    fileprivate func configThumbnail() {
        _ = thumbnail.then {
            $0.layer.cornerRadius = 5
            $0.masksToBounds = true
        }
    }

    fileprivate func addActionForButtons() {
        _ = btnLike.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.like()
                })
        }

        _ = btnFavourite.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.favorite()
                })
        }
    }

    fileprivate func addActionForThumbnail() {
        thumbnail.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        thumbnail.addGestureRecognizer(gesture)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension DetailVideoViewController {

    fileprivate func setData() {
        guard let video = video else {
            return
        }

        setTitle(video.title ?? "")
        thumbnail.kf.setImage(with: video.img_path)
        lbTitle.setSpacingText(video.title ?? "")
        lbContent.setSpacingText(video.desc ?? "")
        lbChannel.text = video.channel_title
        imgChannel.kf.setImage(with: video.channel_img_path)
        btnFavourite.isSelected = video.isFavorited
        btnLike.isSelected = video.isLiked
        showCategory(video.category ?? [])
    }

    fileprivate func showCategory(_ categoryList: [VideoCategoryModel]) {
        let categoryListView = R.nib.videoCategoryView.firstView(owner: nil)
        categoryView.addSubview(categoryListView!)

        constrain(categoryListView!) { (view) in
            view.width == view.superview!.width
            view.height == view.superview!.height
            view.left == view.superview!.left
            view.top == view.superview!.top
        }

        var items = [CategoryItem]()
        for category in categoryList {
            items.append(CategoryItem(title: category.name ?? ""))
        }

        categoryListView?.reloadData(items)
    }

    fileprivate func pageView() {
        p?.pageView(video?.id ?? 0)
    }

    fileprivate func pointGrant() {
        guard let video = video else {
            return
        }
        p?.pointGrant(video.id, type: .video)
    }

    fileprivate func like() {
        guard let video = video else {
            return
        }
        p?.videoLike(video.id)
    }

    fileprivate func favorite() {
        guard let video = video else {
            return
        }
        p?.videoFavorite(video.id, isFavorite: video.favorite_flg) { [weak self] in
            video.favorite_flg = (video.favorite_flg == 1) ? 0 : 1
            self?.btnFavourite.isSelected = video.isFavorited
        }
    }

    fileprivate func calculateContainerSize() {
        let bottomPadding: CGFloat = 0
        let standardHeight = view.frame.height - navHeight - bottomPadding

        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        var contentHeight = (contentRect.size.height - navHeight) + tabBarHeight
        if contentHeight >= standardHeight {
            contentHeight = standardHeight
        } else if contentHeight <= standardHeight - tabBarHeight {
            contentHeight = standardHeight - tabBarHeight
        }

        feedBackViewVisible(!(contentHeight >= standardHeight))
        heightContainerViewConstraint.constant = contentHeight
    }

    fileprivate func fitContainerSize() {
        let sizeForOverlap = view.frame.height - feedBackView.frame.maxY - navHeight
        if sizeForOverlap > 0 && sizeForOverlap < tabBarHeight {
            heightContainerViewConstraint.constant -= (tabBarHeight - sizeForOverlap)
            feedBackViewVisible(true)
        }
    }

    fileprivate func feedBackViewVisible(_ visible: Bool) {
        feedBackView.isHidden = !visible
    }
}

extension DetailVideoViewController {

    override func setTabBarVisible(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        super.setTabBarVisible(visible, animated: animated, duration: duration)
        feedBackViewVisible(!visible)
    }
}

extension DetailVideoViewController {

    @objc fileprivate func playVideo() {
        avPlayer = AVPlayerViewController()
        self.present(avPlayer!, animated: true, completion: nil)

        XCDYouTubeClient.default().getVideoWithIdentifier(video?.videoId ?? "") { [weak self] (video, _) in
            guard let wSelf = self else {
                return
            }
            if let streamURLs = video?.streamURLs,
                let streamURL = (streamURLs[YouTubeVideoQuality.hd720]
                    ?? streamURLs[YouTubeVideoQuality.medium360]
                    ?? streamURLs[YouTubeVideoQuality.small240]) {
                wSelf.avPlayer?.player = AVPlayer(url: streamURL)
                wSelf.avPlayer?.player?.play()
                wSelf.startDate = Date()
                wSelf.avTimer = Timer.scheduledTimer(timeInterval: 1,
                                                      target: wSelf,
                                                      selector: #selector(wSelf.countVideoTimer),
                                                      userInfo: nil,
                                                      repeats: true)
            } else {
                wSelf.dismiss(animated: true, completion: nil)
                wSelf.avPlayer = nil
            }
        }
    }

    @objc fileprivate func countVideoTimer() {
        if let startDate = startDate,
            let timeGrant = video?.time,
            let point = video?.point, point > 0 {
            let currentDate = Date()
            let time = Int(currentDate.timeIntervalSince(startDate))
            print("countVideoTimer: \(time)")
            if time >= timeGrant {
                self.startDate = nil
                avTimer?.invalidate()
                pointGrant()
            }
        } else {
            avTimer?.invalidate()
        }
    }
}

extension DetailVideoViewController: DetailVideoPresenterDelegate {

    func likeCompleted(_ like: LikeModel?) {
        if let like = like, let video = video {
            video.good_flg = (video.good_flg == 1) ? 0 : 1
            video.good = like.good ?? 0
            btnLike.isSelected = video.isLiked
        }
    }

    func pointGrantCompleted(_ point: String) {
        avPlayer?.showVideoGrantPointPopup(point,
                                           size: avPlayer?.view.frame.size ?? CGRect.zero.size)
    }
}
