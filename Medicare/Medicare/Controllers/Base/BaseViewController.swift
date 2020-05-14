//
//  BaseViewController.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import UIKit
import Cartography
import NCMB
import Firebase

class BaseViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet open weak var navigationBar: UINavigationBar?

    // MARK: - Variable

    fileprivate let baseRouter = BaseRouter()
    fileprivate var appLogo: UIImageView?

    fileprivate var preOffset: CGPoint = .zero
    fileprivate var isDragging: Bool = false

    // MARK: - Deinitialize

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(LCLLanguageChangeNotification),
                                                  object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadLocalizedViews),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        setInteractivePopGestureEnabled()
        configView()
        reloadLocalizedViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setTabBarVisible(true, animated: false)
        logEvent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        appLogo?.removeFromSuperview()
    }
}

// MARK: - Custom Methods

extension BaseViewController {

    @objc func configView() {
        if let navigationBar = self.navigationController?.navigationBar {
            self.navigationBar = navigationBar
        }

        baseRouter.viewController = self

        view.backgroundColor = ColorName.cF9F9F9.color

        navigationBar?.backgroundColor = UIColor.white
//        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 18),
                                              NSAttributedString.Key.foregroundColor: ColorName.c333333.color]

        navigationBar?.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        navigationBar?.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationBar?.layer.shadowRadius = 3.0
        navigationBar?.layer.shadowOpacity = 1.0
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }

    func setLogoImageAsTitleView() {
        let logoImage = UIImage.image(fromText: "Medicare",
                                        font: .bold(size: 25),
                                        color: ColorName.c333333.color,
                                        maxSize: CGSize(width: 200, height: 30))
        let titleViewSize = logoImage.size
        let imageViewRect = CGRect(origin: .zero, size: titleViewSize)
        let imageView = UIImageView(frame: imageViewRect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = logoImage

        navigationItem.titleView = imageView
    }

    func clearTitleView() {
        navigationItem.titleView = nil
    }

    func setTitle(_ title: String) {
        navigationItem.title = title
    }

    func addLogoView() {
        appLogo = UIImageView()
        appLogo!.image = R.image.app_logo()
        appLogo!.contentMode = .scaleAspectFit
        navigationBar?.addSubview(appLogo!)

        constrain(appLogo!) { (view) in
            view.width == 128
            view.height == 23
            view.center == view.superview!.center
        }
    }
}

extension BaseViewController {

    func openNotificationList() {
        baseRouter.openNotificationListView()
    }

    @objc func logEvent() {
        var titleName = navigationItem.title ?? ""
        if titleName.isEmpty {
            titleName = title ?? ""
        }

        if let string = getSpecificallyControllerTitle() {
            titleName = string
        }

        if titleName.isEmpty {
            return
        }

        Analytics.setScreenName(titleName, screenClass: self.description)
    }

    fileprivate func getSpecificallyControllerTitle() -> String? {
        if self is HomeViewController {
            return "TOPページ"
        } else if self is SplashViewController {
            return "アプリスタート画面"
        } else if self is SMSAuthenticationViewController {
            return "SMS認証"
        } else if self is OTPAuthenticationViewController {
            return "認証番号"
        } else if self is FirstViewController {
            return "TOP(初回画面)"
        } else if self is DetailMagazineViewController {
            return "フリーマガジン詳細ページ"
        } else if self is DetailVideoViewController {
            return "動画詳細ページ"
        } else if self is DetailGiftViewController {
            return "プレゼント詳細"
        } else if self is DetailNotificationViewController {
            return "お知らせ詳細"
        }

        return nil
    }
}

// MARK: - Rotation

extension BaseViewController {

    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Actions

extension BaseViewController {

    override func actionOpenSearch() {

    }

    override func actionOpenHome() {
        if let controllersInStack = navigationController?.viewControllers,
            controllersInStack.first(where: { $0 is HomeViewController }) != nil {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(StringConstant.reloadTabBarNotification),
                                        object: nil,
                                        userInfo: nil)
    }

    override func actionOpenMyPage() {
        baseRouter.openMyMenu()
    }
}

// MARK: - UIScrollViewDelegate

extension BaseViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            setTabBarVisible(true)
        }

        guard isDragging else {
            preOffset = scrollView.contentOffset

            return
        }

        guard shouldToogleTabBarByScrolling() else {
            preOffset = scrollView.contentOffset

            return
        }

        let scrollDirection: ScrollDirection
        if preOffset.y > scrollView.contentOffset.y {
            scrollDirection = .down
        } else if preOffset.y < scrollView.contentOffset.y {
            scrollDirection = .up
        } else {
            scrollDirection = .none
        }

        preOffset = scrollView.contentOffset

        switch scrollDirection {
        case .up:
            setTabBarVisible(false)
        case .down:
            setTabBarVisible(true)
        default:
            break
        }
    }
}

extension BaseViewController {

    func updateDeviceTokenToCloud(_ userId: Int) {
        guard let token = prefs?.getDeviceToken() else {
            return
        }

        let installation: NCMBInstallation = NCMBInstallation.currentInstallation
        installation.setDeviceTokenFromData(data: token)
        installation["userId"] = userId
        installation.saveInBackground(callback: { result in
            switch result {
            case .success:
                //端末情報の登録が成功した場合の処理
                break
            case let .failure(error):
                //端末情報の登録が失敗した場合の処理
                let errorCode = (error as NSError).code
                if errorCode == 409001 {
                    //失敗した原因がdeviceTokenの重複だった場合
                    self.updateExistInstallation(installation: installation)
                } else {
                    //deviceTokenの重複以外のエラーが返ってきた場合
                }
                return
            }
        })
    }

    fileprivate func updateExistInstallation(installation: NCMBInstallation) {
        var installationQuery: NCMBQuery<NCMBInstallation> = NCMBInstallation.query
        installationQuery.where(field: "deviceToken", equalTo: installation.deviceToken!)
        installationQuery.findInBackground(callback: {results in
            switch results {
            case let .success(data):
                //上書き保存する
                let searchDevice: NCMBInstallation = data.first!
                installation.objectId = searchDevice.objectId
                installation.saveInBackground(callback: { result in
                    switch result {
                    case .success:
                        //端末情報更新に成功したときの処理
                        break
                    case .failure:
                        //端末情報更新に失敗したときの処理
                        break
                    }
                })
            case .failure:
                //端末情報検索に失敗した場合の処理
                break
            }
        })
    }
}
