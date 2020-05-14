//
//  DetailMagazineViewController.swift
//  Medicare
//
//  Created by Thuan on 3/14/20.
//

import Foundation
import Kingfisher

private let topPadding: CGFloat = 15
private let bottomPadding: CGFloat = 10

final class DetailMagazineViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var contentWebView: UIWebView!
    @IBOutlet fileprivate weak var heightContentWebView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var feedBackView: UIView!
    @IBOutlet fileprivate weak var btnLike: UIButton!
    @IBOutlet fileprivate weak var btnFavourite: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightContainerViewConstraint: NSLayoutConstraint!

    // MARK: Variables

    fileprivate var navHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height +
            (self.navigationController?.navigationBar.frame.height ?? 0)
    }
    fileprivate var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0.0
    }
    fileprivate var standardHeight: CGFloat {
        return view.frame.height - navHeight - topPadding - bottomPadding
    }
    var route: DetailMagazineRouter?
    var magazine: MagazineModel?
    fileprivate var p: DetailMagazinePresenter?
    fileprivate var bottomReached = false

    // MARK: - Initialize

    class func newInstance() -> DetailMagazineViewController {
        guard let newInstance = R.storyboard.magazine.detailMagazineViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showWebViewContent(magazine?.url)
    }

    override func viewWillDisappear(_ animated: Bool) {
        dismissHUD()
        super.viewWillDisappear(animated)
    }

    override func actionBack() {
        route?.close()
    }
}

extension DetailMagazineViewController {

    override func configView() {
        super.configView()

        configHeightContainerView()
        configScrollView()
        configWebView()
        configButtons()
        addActionForButtons()
        setData()

        p = DetailMagazinePresenter()
        p?.delegate = self
        pageView()
    }

    fileprivate func configHeightContainerView() {
        heightContainerViewConstraint.constant = standardHeight
    }

    fileprivate func configScrollView() {
        _ = scrollView.then {
            $0.delegate = self
        }
        extendBottomInsetIfNeed(for: scrollView)
    }

    fileprivate func configWebView() {
        _ = contentWebView.then {
            $0.backgroundColor = UIColor.clear
            $0.isOpaque = false
            $0.delegate = self
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

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension DetailMagazineViewController {

    fileprivate func setData() {
        guard let magazine = magazine else {
            return
        }

        setTitle(magazine.title ?? "")
        btnFavourite.isSelected = magazine.isFavorited
        btnLike.isSelected = magazine.isLiked
    }

    fileprivate func showWebViewContent(_ urlStr: String?) {
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            showHUDAndAllowUserInteractionEnabled()
            var request = URLRequest(url: url)
            request.setValue(basicAuthorization, forHTTPHeaderField: "Authorization")
            contentWebView.loadRequest(request)
        } else {
            calculateContainerSize(0.0)
        }
    }

    fileprivate func pageView() {
        p?.pageView(magazine?.id ?? 0)
    }

    fileprivate func pointGrant() {
        guard let magazine = magazine else {
            return
        }

        if let point = magazine.point, point > 0 {
            p?.pointGrant(magazine.id, type: .magazine)
        }
    }

    fileprivate func like() {
        guard let magazine = magazine else {
            return
        }
        p?.magazineLike(magazine.id)
    }

    fileprivate func favorite() {
        guard let magazine = magazine else {
            return
        }
        p?.magazineFavorite(magazine.id, isFavorite: magazine.favorite_flg) { [weak self] in
            magazine.favorite_flg = (magazine.favorite_flg == 1) ? 0 : 1
            self?.btnFavourite.isSelected = magazine.isFavorited
        }
    }

    fileprivate func showGrantPointPopup(_ point: String) {
        let grantPointPopup = GrantPointPopup.newInstance().then {
            $0.point = point
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

    fileprivate func calculateContainerSize(_ extend: CGFloat) {
        var contentHeight = (contentWebView.frame.maxY - navHeight) + tabBarHeight + extend
        if contentHeight >= standardHeight {
            contentHeight = standardHeight
        } else if contentHeight <= standardHeight - tabBarHeight {
            contentHeight = standardHeight - tabBarHeight
        }

        feedBackViewVisible(!(contentHeight >= standardHeight))
        heightContainerViewConstraint.constant = contentHeight
        fitContainerSize(contentHeight)

        if !feedBackView.isHidden {
            bottomReached = true
            pointGrant()
        }
    }

    fileprivate func fitContainerSize(_ contentHeight: CGFloat) {
        let feedBackViewMaxY = contentHeight + topPadding
        let sizeForOverlap = view.frame.height - feedBackViewMaxY - navHeight
        if sizeForOverlap > bottomPadding && sizeForOverlap < tabBarHeight {
            heightContainerViewConstraint.constant -= (tabBarHeight - sizeForOverlap)
            feedBackViewVisible(true)
        }
    }

    fileprivate func feedBackViewVisible(_ visible: Bool) {
        feedBackView.isHidden = !visible
    }
}

extension DetailMagazineViewController {

    override func setTabBarVisible(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        super.setTabBarVisible(visible, animated: animated, duration: duration)
        feedBackViewVisible(!visible)
    }
}

extension DetailMagazineViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)

        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height)
            && !bottomReached {
            bottomReached = true
            pointGrant()
        }
    }
}

extension DetailMagazineViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(_ webView: UIWebView) {
        popHUDActivity()

        /** Update content height webview **/

        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSize.init(width: 0, height: 0))
        webView.scrollView.isScrollEnabled = false
        frame.size = fittingSize
        webView.scalesPageToFit = true
        calculateContainerSize(frame.height)
        heightContentWebView.constant = frame.height
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        popHUDActivity()
        calculateContainerSize(0.0)
    }
}

extension DetailMagazineViewController: DetailMagazinePresenterDelegate {

    func likeCompleted(_ like: LikeModel?) {
        if let like = like, let magazine = magazine {
            magazine.good_flg = (magazine.good_flg == 1) ? 0 : 1
            magazine.good = like.good ?? 0
            btnLike.isSelected = magazine.isLiked
        }
    }

    func pointGrantCompleted(_ point: String) {
        showGrantPointPopup(point)
    }
}
